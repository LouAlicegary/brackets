class BracketDataScraper

  require 'open-uri'
  require 'mechanize'

  @@league = ENV['LEAGUE']
  @@server = "http://#{@@league}.mayhem.cbssports.com"
  @@standings = "/brackets/standings"

  @@username = ENV['USERNAME']
  @@password = ENV['PASSWORD']

  # Runs upon class instantiation
  def initialize
    @agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  end

  # Runs
  def get_bracket_data

    picks = Array.new

    # Grab login page
    @agent.get(@@server + @@standings) do |login_page|
      
      # Login and fetch the standings page
      standings_page = do_login(login_page)
      
      group_id = Group.find_by(name: @@league).to_i
      if (group_id) == 0
        # Get the links to the brackets off the standings page
        group_id = Group.create(name: @@league).to_i
        brackets = get_brackets(group_id, standings_page)

        # Parse each player's bracket
        brackets.each do |bracket|
          picks << parse_bracket(bracket)
        end
      else
        picks = Group.find_by(id: group_id).brackets
      end

    end   
    
    picks

  end

  private 

    # Logs into login page and clicks button, which redirects to group page
    # Returns the new page
    def do_login page
      page = page.form_with(action: "/login") do |f|
        f.userid = @@username
        f.password = @@password
      end.click_button      
    end

    # Parses through all bracket links on main page and makes Bracket objects in DB
    # Returns an array of bracket objects
    def get_brackets group_id, page
      brackets = Array.new
      page.links.each do |link|
        next unless /(#{@@server})\/(brackets)\/\d+\/\d+/.match(link.href)
        bracket = Bracket.find_or_create_by(bracket_params(group_id, link))
        brackets << bracket
      end
      brackets      
    end


    # This occurs for each links that's scraped off the group page
    # Returns an array of all the games / picks
    def parse_bracket bracket

      #if Bracket.find_by()

      # Scrapes bracket data as JSON      
      bracket_json = scrape_bracket bracket.link

      return_data = Array.new

      # Creates round and game arrays and stores DB records
      bracket_json["game_and_pick_list"]["regions"].each do |region|
        region["rounds"].each do |round|
          round["games"].each do |game|
            pick = create_pick(bracket.id, game)
            return_data << get_game_blob(pick, game)
          end
        end
      end

      return_data
    end

    # Called by parse_bracket. Scrapes a JSON representation of all game / pick data from site JS
    def scrape_bracket url
      bracket_json = Hash.new
      @agent.get(url) do |bracket_page|
        script_data = bracket_page.search('script').to_s
        bracket_script = script_data.split('bootstrapBracketsData = ')[1]
        bracket_info = bracket_script.split('opm_transfer')[0][0..-4].concat("}}")
        bracket_json = JSON.parse(bracket_info)
      end
      bracket_json      
    end


    def create_pick bracket_id, game_json
      Pick.create(pick_params(bracket_id, game_json))
    end

    # Build team/game/pick hash to return to view
    def get_game_blob pick, game_json
      return_hash = Hash.new
      return_hash[:home_team] = Team.find_by(cbs_id: game_json["home_id"])
      return_hash[:away_team] = Team.find_by(cbs_id: game_json["away_id"])
      return_hash[:game] = Game.find_by(cbs_id: game_json["cbs_game_id"])
      return_hash[:pick] = pick
      return_hash
    end

    # Strong Params for Bracket record creation
    def bracket_params group_id, params
      sanitized_hash = Hash.new
      sanitized_hash[:group_id] = group_id
      sanitized_hash[:name] = params.text
      sanitized_hash[:link] = params.href
      
      sanitized_hash
    end


    # Strong Params for Pick record creation
    # bracket_id ; game_id ; team_id ; result
    def pick_params bracket_id, params
      
      sanitized_hash = Hash.new
      sanitized_hash[:bracket_id] = bracket_id
      sanitized_hash[:game_id] = Game.find_by(cbs_id: params["cbs_game_id"]).to_i
      sanitized_hash[:team_id] = Team.find_by(abbr: params["user_pick"]["pick"]).to_i
      sanitized_hash[:result] = params["user_pick"]["result"]
      
      sanitized_hash
    end



end






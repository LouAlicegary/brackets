class TournamentDataScraper

  require 'open-uri'
  require 'mechanize'

  @@league = ENV['LEAGUE']
  
  @@server = "http://#{}.mayhem.cbssports.com"
  @@standings = "/brackets/standings"

  @@username = ENV['USERNAME']
  @@password = ENV['PASSWORD']

  # Runs upon class instantiation
  def initialize
    @agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    wipe_database
  end

  # This is the main "runner" method for the class
  def seed_db

    # Grab login page
    @agent.get(@@server + @@standings) do |login_page|
      
      # Login and fetch the standings page
      standings_page = do_login(login_page)
      
      # Get a link to a random bracket (the first one)
      bracket_link = ""
      standings_page.links.each do |link|
        next unless /(#{@@server})\/(brackets)\/\d+\/\d+/.match(link.href)
        bracket_link = link.href
        break
      end

      # Pull in the regions, teams, and games from the bracket page and store them in the DB
      scrape_data_and_create_records(bracket_link)

    end   

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
    def get_link_to_first_bracket page
      link = page.links.first      
    end


    # This occurs for each links that's scraped off the group page
    # Returns an array of all the games / picks
    def scrape_data_and_create_records link

      # Scrapes bracket/game data as JSON      
      bracket_json = scrape_bracket link
      games_json = get_games_json bracket_json

      create_regions bracket_json
      create_teams games_json
      create_games games_json

    end


    # Takes a URL and returns a JSON representation of all game / pick data from site JS
    def scrape_bracket url
      @agent.get(url) do |bracket_page|
        return JSON.parse(bracket_page.search('script').to_s.split('bootstrapBracketsData = ')[1].split('opm_transfer')[0][0..-4].concat("}}"))
      end    
    end

    # Get a JSON representation of every game from every region 
    # (round-by-round instead of region-by-region, like bracket_json)
    def get_games_json bracket_json
      return_data = Array.new

      bracket_json["game_and_pick_list"]["regions"].each do |region|
        region["rounds"].each do |round|
          round["games"].each { |game| return_data << game }
        end
      end

      return_data
    end


    # Creates DB records for all regions
    def create_regions bracket_json
      region_array = bracket_json["game_and_pick_list"]["regions"]
      region_array.each do |region|
        Region.create({name: region['name']})
      end
    end

    def create_teams games_json
      games_json.each do |game|
        if game["round_id"].to_i == 1
          Team.create(home_team_params(game))
          Team.create(away_team_params(game))
        end
      end
    end


    def create_games games_json
      games_json.each do |game|
        Game.create(game_params(game))
      end
    end


    # Strong Params for Home team record creation
    def home_team_params params
      sanitized_hash = Hash.new
      sanitized_hash[:cbs_id] = params["home_id"]
      sanitized_hash[:abbr] = params["home_abbr"]
      sanitized_hash[:name] = params["home_name"]
      sanitized_hash[:seed] = params["home_seed"]
      
      sanitized_hash
    end

    # Strong Params for Away team record creation
    def away_team_params params
      sanitized_hash = Hash.new
      sanitized_hash[:cbs_id] = params["away_id"]
      sanitized_hash[:abbr] = params["away_abbr"]
      sanitized_hash[:name] = params["away_name"]
      sanitized_hash[:seed] = params["away_seed"]
      
      sanitized_hash
    end

    # Strong Params for Game record creation
    def game_params params

      sanitized_hash = Hash.new
      sanitized_hash[:cbs_id] = params["cbs_game_id"]
      sanitized_hash[:round_id] = params["round_id"]
      sanitized_hash[:game_date] = params["game_date"]
      sanitized_hash[:region] = params["region_id"]
      sanitized_hash[:html_id] = params["id"]
      sanitized_hash[:html_id_next] = params["next_round_game_id_for_pick"]
      sanitized_hash[:next_round_placement_for_pick] = params["next_round_placement_for_pick"]

      sanitized_hash[:home_team_id] = Team.find_by(cbs_id: params["home_id"]) if params["home_id"].present?
      sanitized_hash[:away_team_id] = Team.find_by(cbs_id: params["away_id"]) if params["away_id"].present?
      sanitized_hash[:winner_id] = Team.find_by(cbs_id: params["winner_id"]) if params["winner_id"].present?

      # "status" => "F",
      # "next_round_placement_for_pick" => "top",
      # "cbs_game_abbr" => "NCAAB_20150319_HAMP@UK", 
      # "away_score" => "56"
      # "period" => "2",
      # "home_score" => "79",
      # "time_remaining" => "00000",

      sanitized_hash
    end    


    def wipe_database
      Group.destroy_all
      Bracket.destroy_all
      Region.destroy_all
      Team.destroy_all
      Game.destroy_all
      Pick.destroy_all
    end


end






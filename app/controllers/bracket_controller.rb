class BracketController < ApplicationController
  def index
    
    # tournament_data = TournamentDataScraper.new
    # tournament_data.seed_db

    # bracket_data = BracketDataScraper.new
    # bracket_data.get_bracket_data

    @bracket = Bracket.find_by(name: "Lou Alicegary")

  end
end

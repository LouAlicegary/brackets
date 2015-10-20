var Game = new function() {

	this.get = function(in_id) {
		
		var return_game = {};
		
		var data = JSON.parse(localStorage['group']);
		$.each(data.games, function( index, game ) {
  			if (game.id == in_id) {
  				return_game = game;		
  			}

		});

		return return_game;
	};

	
	this.set = function(bracket_data) {
		//localStorage['group'] = JSON.stringify bracket_data
	};


	this.getByHtmlId = function(in_html_id) {

		var return_game = {};
		
		var data = JSON.parse(localStorage['group']);
		$.each(data.games, function(index, game) {
  			if (game.html_id === in_html_id) {
  				return_game = game;		
  			}

		});
		return return_game;		

	};

	this.getPreviousGameByHtmlId = function(in_html_id) {

		var return_game = {};
		
		var data = JSON.parse(localStorage['group']);
		$.each(data.games, function(index, game) {
			console.log("noooo", in_html_id.slice(0,-2));
  			if (game.html_id_next === in_html_id.slice(0,-2)) {
  				console.log("yoooo", in_html_id.slice(0,-2));
  				if ( (game.next_round_placement_for_pick == "top" && in_html_id.slice(-1) == "1") || (game.next_round_placement_for_pick == "bottom" && in_html_id.slice(-1) == "2") )
  				return_game = game;		
  			}

		});
		return return_game;		

	};

	this.updateHomeTeam = function(game_id, team_id) {
		var bracket_data = Group.get();

		$.each(bracket_data.games, function(index, game) {
			if (game.id == game_id) {
				game.home_team_id = team_id;
				return false;
			}
		});
		localStorage['group'] = JSON.stringify(bracket_data);

		return bracket_data;
	};



	this.updateAwayTeam = function(game_id, team_id) {
		var bracket_data = Group.get();

		$.each(bracket_data.games, function(index, game) {
			if (game.id == game_id) {
				game.away_team_id = team_id;			
				return false;
			}
		});
		localStorage['group'] = JSON.stringify(bracket_data);

		return bracket_data;
	};


};
var Bracket = new function() {


	this.numberCorrect = function(bracket) {
		var correct = 0;
		$.each(bracket.picks, function(index, pick) {
			if (pick.result == 'right') 
				correct += 1;
		});
		return correct;
	};



	this.currentScore = function(bracket) {
		var score = 0;
		$.each(bracket.picks, function(index, pick) {
			if (pick.result == 'right') {
				var seed = Team.get(pick.team_id).seed;
				var game = Game.get(pick.game_id);
				var round = game.round_id;

				var weight = Math.pow(2, round-1);
				
				score += (weight * seed);

			}
		});
		return score;
	};


	this.getHomeOrAway = function(this_id) {
	  	var homeaway = "";

	    //Parsing region, round, and game from html_id attribute of Game (which is the DOM ID)
	    var region = parseInt(this_id.split("-")[0]);
	    var round = parseInt(this_id.split("-")[1]);
	    var game = parseInt(this_id.split("-")[2]);
	  	
	  	if (round == 3) {
		    homeaway = (game == 1) ? ("home") : ("away");
		} else if (round == 4) {
	  		homeaway = (region % 2) ? ("home") : ("away");	
	  	} else if (round == 5) {
	  		homeaway = (game == 1) ? ("home") : ("away");
	  	}
	  	return homeaway;
	};


};
var Group = new function() {

	self = this;

	this.get = function() {
		return JSON.parse(localStorage['group']);
	};
	
	this.set = function(data) {
		localStorage['group'] = JSON.stringify(data);
		return JSON.parse(localStorage['group']);
	};

	this.updateBrackets = function(html_id) {
		var group = self.get();
		var winning_team;
		var return_data = {};

		game = Game.getByHtmlId(html_id.slice(0,-2));

		// Gets the selected team based on the -1 or -2 at the end of the ID
		prev_game = Game.getPreviousGameByHtmlId(html_id);
		winning_team = Team.get(prev_game.winner_id);

		// Updates the next round's game
		if (game.get_round_placement_for_pick == "top")
            group = Game.updateHomeTeam(html_id, game.html_id_next);   
        else
            group = Game.updateAwayTeam(html_id, game.html_id_next); 
		

		// Iterate through each bracket for this specific pick and give points. 
		$.each(group.brackets, function(index, bracket) {
			$.each(bracket.picks, function(index, pick) {
				if (game.id == pick.game_id) {
					var picked_team = Team.get(pick.team_id);
					console.log("Winning Team: ", Team.get(winning_team.id).name, " / Chosen Team: ", Team.get(picked_team.id).name);
					return_data = (picked_team.id == winning_team.id) ? (Pick.updateResult(pick.id, "right")) : (Pick.updateResult(pick.id, "wrong"));
					return false; //breaks the inner each loop
				}
			});
		});


		return return_data;
	};

};
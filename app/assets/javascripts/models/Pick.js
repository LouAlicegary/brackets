var Pick = new function() {

	this.get = function(in_id) {
		
		var return_pick = {};
		
		var data = JSON.parse(localStorage['group']);
		$.each(data.brackets, function(index, bracket) {
			$.each(bracket.picks, function(index, pick) {
	  			if (pick.id == in_id) {
	  				return_pick = pick;		
					return false;
				}
			});
			if (flag) {
				return false;
			}
		});

		return return_pick;
	};

	this.getPickScore = function(pick, game) {
		var score = 0
		$.each(bracket.picks, function(index, pick) {
			if (pick.result == 'right') {
				score += 1;
			}
		});
		return score;
	};

	this.updateResult = function(pick_id, result) {
		console.log("Update Pick:  pick_id / result = ", pick_id, "/", result);
		var data = Group.get();
		var flag = false;
		$.each(data.brackets, function(index, bracket) {
			$.each(bracket.picks, function(index, pick) {
				if (pick.id == pick_id) {
					pick.result = result;
					flag = true;
					return false;
				}
			});
			if (flag) {
				return false;
			}
		});
		localStorage['group'] = JSON.stringify(data);

		return data;
	};

};
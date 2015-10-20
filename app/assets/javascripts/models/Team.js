var Team = new function() {

	this.get = function(in_id) {
		var data = JSON.parse(localStorage['group']);
		var team = {};
		$.each(data.teams, function( index, value ) {
  			if (value.id === in_id) {
  				team = value;
  				//break;
  			}

		});
		return team;
	};
	
	this.set = function(bracket_data) {
		//localStorage['group'] = JSON.stringify bracket_data
	};



};

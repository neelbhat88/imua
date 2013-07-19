var Badges = new function() {
	var self = this;

	self.viewModel = {
		semester: ko.observable(1),
		semesters: [1, 2, 3, 4, 5, 6, 7, 8]
	};

	// Initializes ViewModel
	self.init = function() {	
		$(document).ready(function() {			
			$.ajax({
				url: '/global_badges',				
				success: function(data) {
					var json = data;
					self.viewModel.badges = ko.mapping.fromJS(json.badges);
					self.viewModel.badgesEarned = json.badgesearned;
					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial badge load");}
			});			
		});
	};

	// Subscribe to drop down change and update the UI accordingly
	self.viewModel.semester.subscribe(function(newValue) {
		$.ajax({
			url: '/global_badges',
			data: {semester: newValue},
			success: function(data) {
				var json = data;
				ko.mapping.fromJS(json, self.viewModel.badges);
			},
			error: function() { alert("Failed initial badge load");}
		});
	});
};
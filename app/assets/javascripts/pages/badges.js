var Badges = new function() {
	var self = this;

	self.viewModel = {
		semester: ko.observable(1),
		semesters: [
			{id: 1, text: 'Semester 1'},
			{id: 2, text: 'Semester 2'},
			{id: 3, text: 'Semester 3'},
			{id: 4, text: 'Semester 4'},
			{id: 5, text: 'Semester 5'},
			{id: 6, text: 'Semester 6'},
			{id: 7, text: 'Semester 7'},
			{id: 8, text: 'Semester 8'}
		]
	};	

	// Initializes ViewModel
	self.init = function() {
		$(document).ready(function() {			
			$.ajax({
				url: '/global_badges',
				data: null,
				success: function(data) {
					var json = data;
					self.viewModel.badges = ko.mapping.fromJS(json.badges);
					self.viewModel.badgesEarned = ko.observable(json.badgesearned);
					self.viewModel.semester(json.semester);
					ko.applyBindings(self.viewModel);

					Header.setPageContainerHeight();
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
				ko.mapping.fromJS(json.badges, self.viewModel.badges);
			},
			error: function() { alert("Failed initial badge load");}
		});
	});
};
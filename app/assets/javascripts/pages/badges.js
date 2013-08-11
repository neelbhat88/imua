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
		],	
	};	

	// Initializes ViewModel
	self.init = function() {
		$(document).ready(function() {			
			$.ajax({				
				url: '/global_badges',				
				success: function(data) {
					var json = data;
					self.viewModel.badges = ko.mapping.fromJS(json.badges);
					self.viewModel.badgesEarned = ko.observable(json.badgesearned);
					self.viewModel.semester(json.semester);
					ko.applyBindings(self.viewModel);					
				},
				error: function() { alert("Failed initial badge load");}
			});			
		});
	};

	// Subscribe to drop down change and update the UI accordingly
	self.viewModel.semester.subscribe(function(newValue) {
		$.ajax({
			type: "POST",
			url: '/global_badges/semester',
			data: {semester: newValue},
			success: function(data) {
				var json = data;
				ko.mapping.fromJS(json.badges, self.viewModel.badges);
			},
			error: function() { alert("Failed drop down subscribe ajax post");}
		});
	});
};

function getBadgeColor(badge) {
	if (!badge.hasEarned())
		return "hasNotEarned";

	switch(badge.category())
	{
		case "Academics": 
			return "academics_bg";
		case "Activity": 
			return "extracur_bg";
		case "Service": 
			return "service_bg";
		case "PDU": 
			return "pdu_bg";
	}			
}
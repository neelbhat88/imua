var Activities = new function() {
	var self = this;

	self.viewModel = {
		leadershipHeld: ko.observable(false),

		addLeadership: function(){
			self.viewModel.leadershipHeld(true);
		}
	};

	self.init = function() {
		$(document).ready(function() {
			// $.ajax({
			// 	url: '/academics',
			// 	success: function(data) {					
			// 		self.viewModel.subjects = ko.mapping.fromJS(data.userclasses);
			// 		self.viewModel.originalSubjects = data.userclasses;
			// 		self.viewModel.globalsubjects = ko.mapping.fromJS(data.globalclasses);

			// 		ViewModelPropertiesInit(self.viewModel);			

			// 		ko.applyBindings(self.viewModel);
			// 	},
			// 	error: function() { alert("Failed initial badge load");}
			// });
			ko.applyBindings(self.viewModel);
		});
	};
};

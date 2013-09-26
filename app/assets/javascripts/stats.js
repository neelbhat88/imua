var Stats = new function() {	
	var self = this;

	self.viewModel = {
		pageLoaded: ko.observable(false),

		totalBadgesEarned: ko.observable(0),
		totalBadgesPossible: ko.observable(0),
		totalBadgesValue: ko.observable(0),
		totalDeductions: ko.observable(0),
		finalBadgesValue: ko.observable(0),
		cumulativeGpa: ko.observable(0.00),
		totalActivities: ko.observable(0),
		totalService: ko.observable(0),
		totalPdus: ko.observable(0),

		showDeductionsModal: function() {
			$('#deductionsModal').modal();			
		}
	};

	// Initializes ViewModel
	self.init = function() {
		$(document).ready(function() {
			$.ajax({				
				url: '/stats',				
				success: function(data) {
					self.viewModel.totalBadgesEarned(data.totalbadgesearned);
					self.viewModel.totalBadgesPossible(data.totalbadgespossible);
					self.viewModel.totalBadgesValue(data.totalbadgesvalue);
					self.viewModel.cumulativeGpa(data.cumulativegpa);
					self.viewModel.totalActivities(data.totalactivities);
					self.viewModel.totalService(data.totalservice);
					self.viewModel.totalPdus(data.totalpdus);

					self.viewModel.finalBadgesValue(self.viewModel.totalBadgesValue() - self.viewModel.totalDeductions());
					
					self.viewModel.pageLoaded(true);
					
					ko.applyBindings(self.viewModel);					
				},
				error: function() { alert("Failed initial stats load");}
			});			
		});
	};	
};
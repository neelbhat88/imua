$(function(){
	Stats = function() {
		var self = this;

		new Header().SetSelectedMenuItem('Stats');

		self.viewModel = {
			pageLoaded: ko.observable(false),

			totalBadgesEarned: ko.observable(0),
			totalBadgesPossible: ko.observable(0),
			totalBadgesValue: ko.observable(0),		
			finalBadgesValue: ko.observable(0),
			cumulativeGpa: ko.observable(0.00),
			totalActivities: ko.observable(0),
			totalService: ko.observable(0),
			totalPdus: ko.observable(0),
			totalDeductionValue: ko.observable(0),
			totalDeductions: [],

			showDeductionsModal: function() {
				$('#deductionsModal').modal();			
			}
		};		
	}

	// Initializes ViewModel
	Stats.prototype.init = function() {
		var self = this;

		$(document).ready(function() {
			$.ajax({				
				url: '/stats/init',				
				success: function(data) {
					self.viewModel.totalBadgesEarned(data.totalbadgesearned);
					self.viewModel.totalBadgesPossible(data.totalbadgespossible);
					self.viewModel.totalBadgesValue(data.totalbadgesvalue);
					self.viewModel.cumulativeGpa(data.cumulativegpa);
					self.viewModel.totalActivities(data.totalactivities);
					self.viewModel.totalService(data.totalservice);
					self.viewModel.totalPdus(data.totalpdus);

					self.viewModel.totalDeductionValue(data.totaldeductionvalue);
					ko.mapping.fromJS(data.totaldeductionslist, {}, self.viewModel.totalDeductions);

					self.viewModel.finalBadgesValue(self.viewModel.totalBadgesValue() - self.viewModel.totalDeductionValue());
					
					self.viewModel.pageLoaded(true);
					
					ko.applyBindings(self.viewModel);					
				},
				error: function() { alert("Failed initial stats load");}
			});			
		});
	}
});
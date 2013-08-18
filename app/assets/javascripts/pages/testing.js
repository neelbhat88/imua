var Testing = new function() {
	var self = this;

	self.viewModel = {				
		editing: ko.observable(false),
		pageLoaded: ko.observable(false),
		rowsToRemove: [],

		add: function() {
			self.viewModel.totalTests.push(new Test(null, null));
			
			$('.datepick').datepicker({autoclose: true});
		},

		remove: function(toRemove) {
			if (toRemove.dbid() != null)
				self.viewModel.rowsToRemove.push(toRemove);

			self.viewModel.totalTests.remove(toRemove);
		},	

		save: function()
		{		
			var hasErrors = false;
			$.each(self.viewModel.totalTests(), function() {
				if (this.global_exam_id() == null || this.date() == null || this.score() == null)
				{
					hasErrors = true;
					return false; // Break out of the loop			
				}
			})

			if (hasErrors == true)
			{
				$('.validationError').fadeIn();
				$('.testingEdit select, .testingEdit input').each(function(){
					if (this.value == "")
						$(this).addClass('error');
					else
						$(this).removeClass('error');
				});
				return;
			}

			$.ajax({
				type: "POST",
				url: '/saveTesting',
				data: {
					tests: ko.toJSON(self.viewModel.totalTests()), 
					toRemove: ko.toJSON(self.viewModel.rowsToRemove)
				},
				success: function(data) 
				{					
					ko.mapping.fromJS(data.newtests, {}, self.viewModel.totalTests);
					ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);

					self.viewModel.originalTests = data.newtests;

					self.viewModel.rowsToRemove = [];
					self.viewModel.editing(false);
				},
				error: function() {alert('SaveTesting fail!');}
			});		
		},

		cancelEdit: function()
		{
			// Set back to original			
			ko.mapping.fromJS(self.viewModel.originalTests, {}, self.viewModel.totalTests);

			self.viewModel.rowsToRemove = [];
			self.viewModel.editing(false);
		},

		edit: function()
		{		
			self.viewModel.editing(true);

			$('.datepick').datepicker({autoclose: true});
		},

		templateToUse: function()
		{
			return self.viewModel.editing() ? 'edit' : 'view';
		},	
	};

	self.init = function() {
		self.viewModel.editing = ko.observable(false);

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/testing',
				success: function(data) {					
					self.viewModel.totalTests = ko.mapping.fromJS(data.usertests);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);
					
					self.viewModel.originalTests = data.usertests;
					self.viewModel.globalExams = ko.mapping.fromJS(data.globalexams);

					self.viewModel.pageLoaded(true);
					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial testing load");}
			});
		});
	};

	function Test(date, score)
	{
		var self = this;
		
		self.date = ko.observable(date);
		self.score = ko.observable(score);

		self.global_exam_id = ko.observable("");
		self.dbid = ko.observable("");
	}
};

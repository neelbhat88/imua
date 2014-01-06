$(function(){	
	Testing = function(user_id, isTeacher) 
	{
		var self = this;

		self.UserId = user_id;
		self.IsTeacher = isTeacher;

		self.viewModel = {				
			editing: ko.observable(false),
			submitting: ko.observable(false),
			pageLoaded: ko.observable(false),
			rowsToRemove: [],
			semesters: [],
			semester: ko.observable(1),
			editable: ko.observable(true),
			isShowACT: ko.observable(false),

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
				if (!self.viewModel.submitting())
				{
					if ($('select.error, input.error').length > 0)
					{
						$('.validationError').fadeIn();				
						return;
					}

					self.viewModel.submitting(true);

					$.ajax({
						type: "POST",
						url: '/saveTesting',
						data: {
							tests: ko.toJSON(self.viewModel.totalTests()), 
							toRemove: ko.toJSON(self.viewModel.rowsToRemove),
							semester: self.viewModel.semester(),
							user_id: self.UserId
						},
						success: function(data) 
						{					
							ko.mapping.fromJS(data.newtests, {}, self.viewModel.totalTests);
							ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);

							self.viewModel.originalTests = data.newtests;

							self.viewModel.rowsToRemove = [];
							self.viewModel.editing(false);
							self.viewModel.submitting(false);
						},
						error: function() {alert('SaveTesting fail!');}
					});
				}
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

			showACT: function(show, data)	{
				self.viewModel.isShowACT(show);
			}
		}

		// Subscribe to drop down change and update the UI accordingly
		self.viewModel.semester.subscribe(function(newValue) {
			if (self.viewModel.pageLoaded()) {
				$.ajax({
					type: "POST",
					url: '/testing/init',
					data: {semester: newValue, user_id: self.UserId, isTeacher: self.IsTeacher},
					success: function(data) {				
						ko.mapping.fromJS(data.usertests, {}, self.viewModel.totalTests);
						ko.mapping.fromJS(data.practicetests, {}, self.viewModel.practiceTests);
						ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);
						self.viewModel.editable(data.editable);
					},
					error: function() { alert("Failed drop down subscribe ajax post");}
				});
			}
		});
	}

	Testing.prototype.init = function() 
	{
		var self = this;

		self.viewModel.editing = ko.observable(false);

		var validationMapping = {
			score: {
				create: function(options) {
					return ko.observable(options.data).extend({positiveNum:"Score"});
				}
			},
			date: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			},
			global_exam_id: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			}
		};

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/testing/init',
				data: {user_id: self.UserId, isTeacher: self.IsTeacher},				
				success: function(data) {					
					self.viewModel.totalTests = ko.mapping.fromJS(data.usertests, validationMapping);
					self.viewModel.practiceTests = ko.mapping.fromJS(data.practicetests);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);
					
					self.viewModel.originalTests = data.usertests;
					self.viewModel.globalExams = ko.mapping.fromJS(data.globalexams);

					self.viewModel.semesters = data.semesters;
					self.viewModel.semester(data.init_semester);
					self.viewModel.editable(data.editable);

					self.viewModel.pageLoaded(true);
					ko.applyBindings(self.viewModel);

					// Need to make this into a data-bind click since we lose this after
					// the template changes on edit
					$('.collapsible > .header').click(function(){
						$(this).siblings('.content').toggle();
					});
				},
				error: function() { alert("Failed initial testing load");}
			});

			// Set up click handlers on the test type buttons
			// $('.testTypeButton').click(function(){
			// 	$('.testTypeButton').removeClass('selected');
			// 	$(this).addClass('selected');
			// });

			$('#practiceQuizImg').popover({
				trigger: 'hover',
				placement: 'bottom',
				content: "Click to take your ACT practice quizzes with Varsity Tutors!"
			});			
		});
	}	

	function Test(date, score)
	{
		var self = this;
		
		self.date = ko.observable(date).extend({required: ""});
		self.score = ko.observable(score).extend({positiveNum: "Score"});

		self.global_exam_id = ko.observable("").extend({required: ""});
		self.dbid = ko.observable("");
	}
});

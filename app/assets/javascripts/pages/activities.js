$(function(){
	Activities = function(user_id, isTeacher) 
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

			addActivity: function() {
				// Passing in leadership title so validation does not fail. Since 
				// leadershipHeld is false the title does not matter
				self.viewModel.activities.push(new Activity("", false, "Leader", []));
			},

			removeActivity: function(activityToRemove) {
				if (activityToRemove.dbid() != null)
					self.viewModel.rowsToRemove.push(activityToRemove);

				self.viewModel.activities.remove(activityToRemove);
			},

			addSentence: function(activity, event) {
				activity.description.push(new Sentence(''));
			},

			removeSentence: function(activity, sentenceToRemove)
			{
				activity.description.remove(sentenceToRemove);
			},

			saveActivities: function()
			{
				if (!self.viewModel.submitting())
				{				
					if ($('select.error:visible, input.error:visible').length > 0)
					{
						$('.validationError').fadeIn();				
						return;
					}

					self.viewModel.submitting(true);
					$.ajax({
						type: "POST",
						url: '/saveActivities',
						data: {
							activities: ko.toJSON(self.viewModel.activities()), 
							activitiesToRemove: ko.toJSON(self.viewModel.rowsToRemove),
							semester: self.viewModel.semester(),
							user_id: self.UserId
						},
						success: function(data) 
						{					
							ko.mapping.fromJS(data.newactivities, {}, self.viewModel.activities);
							ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);

							self.viewModel.originalActivities = data.newactivities;

							self.viewModel.rowsToRemove = [];
							self.viewModel.editing(false);
							self.viewModel.submitting(false);					
						},
						error: function() {alert('SaveClasses fail!');}
					});
				}
			},

			cancelEdit: function()
			{
				// Set back to original activities
				ko.mapping.fromJS(self.viewModel.originalActivities, {}, self.viewModel.activities);

				self.viewModel.rowsToRemove = [];
				self.viewModel.editing(false);
			},

			editActivities: function()
			{		
				self.viewModel.editing(true);
			},

			templateToUse: function()
			{
				return self.viewModel.editing() ? 'edit-activities' : 'view-activities';
			}

		}

		// Subscribe to drop down change and update the UI accordingly
		self.viewModel.semester.subscribe(function(newValue) {
			if (self.viewModel.pageLoaded())
			{		
				$.ajax({
					type: "POST",
					url: '/activities/init',
					data: {semester: newValue, user_id: self.UserId, isTeacher: self.IsTeacher},
					success: function(data) {				
						ko.mapping.fromJS(data.useractivities, {}, self.viewModel.activities);
						ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);
						self.viewModel.editable(data.editable);
					},
					error: function() { alert("Failed drop down subscribe ajax post");}
				});
			}
		});
	}

	Activities.prototype.init = function() {
		var self = this;

		self.viewModel.editing(false);

		var validationMapping = {
			leadershipTitle: {
				create: function(options) {
					title = options.data;
					return ko.observable(title).extend({required: ""});
				}
			},			
			school_activity_id: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			}
		};

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/activities/init',
				data: {user_id: self.UserId, isTeacher: self.IsTeacher},
				success: function(data) {					
					self.viewModel.activities = ko.mapping.fromJS(data.useractivities, validationMapping);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);					
					self.viewModel.globalactivities = ko.mapping.fromJS(data.globalactivities);

					self.viewModel.originalActivities = data.useractivities;

					self.viewModel.semesters = data.semesters;
					self.viewModel.semester(data.init_semester);
					self.viewModel.editable(data.editable);
					
					ko.applyBindings(self.viewModel);
					self.viewModel.pageLoaded(true);
				},
				error: function() { alert("Failed initial activity load");}
			});			
		});
	}	

	function Activity(name, leadershipHeld, leadershipTitle, description)
	{
		var self = this;

		self.leadershipTitle = ko.observable(leadershipTitle).extend({required: ""});
		self.leadershipHeld = ko.observable(leadershipHeld);
		self.description = ko.observableArray(description);
		self.school_activity_id = ko.observable().extend({required: ""});
		self.dbid = ko.observable("");
	}

	function Sentence(text)
	{
		var self = this;

		self.text = ko.observable(text);
	}
});


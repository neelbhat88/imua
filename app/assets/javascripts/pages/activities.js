var Activities = new function() {
	var self = this;

	self.viewModel = {			
		editing: ko.observable(false),
		pageLoaded: ko.observable(false),
		rowsToRemove: [],

		addLeadership: function(activity, event){
			activity.leadershipHeld(true);
		},

		removeLeadership: function(activity, event){
			activity.leadershipTitle(null);
			activity.leadershipHeld(false);
		},

		addActivity: function() {
			self.viewModel.activities.push(new Activity("", false, "", []));
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
			var hasErrors = false;
			$.each(self.viewModel.activities(), function() {
				if (this.school_activity_id() == null || (this.leadershipHeld() && this.leadershipTitle() == ""))
				{
					hasErrors = true;
					return false; // Break out of the loop			
				}
			})

			if (hasErrors == true)
			{
				$('.validationError').fadeIn();
				$('.activitiesEdit select, .activitiesEdit input').each(function(){
					if (this.value == "")
						$(this).addClass('error');
					else
						$(this).removeClass('error');
				});
				return;
			}

			$.ajax({
				type: "POST",
				url: '/saveActivities',
				data: {
					activities: ko.toJSON(self.viewModel.activities()), 
					activitiesToRemove: ko.toJSON(self.viewModel.rowsToRemove)
				},
				success: function(data) 
				{					
					ko.mapping.fromJS(data.newactivities, {}, self.viewModel.activities);
					ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);

					self.viewModel.originalActivities = data.newactivities;

					self.viewModel.rowsToRemove = [];
					self.viewModel.editing(false);					
				},
				error: function() {alert('SaveClasses fail!');}
			});		
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

	};

	self.init = function() {
		self.viewModel.editing = ko.observable(false);

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/activities',
				success: function(data) {					
					self.viewModel.activities = ko.mapping.fromJS(data.useractivities);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);					
					self.viewModel.globalactivities = ko.mapping.fromJS(data.globalactivities);

					self.viewModel.originalActivities = data.useractivities;

					self.viewModel.pageLoaded(true);
					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial activity load");}
			});			
		});
	};

	function Activity(name, leadershipHeld, leadershipTitle, description)
	{
		var self = this;

		self.name = ko.observable(name);
		self.leadershipHeld = ko.observable(leadershipHeld);
		self.leadershipTitle = ko.observable(leadershipTitle);
		self.description = ko.observableArray(description);
		self.school_activity_id = ko.observable()
		self.dbid = ko.observable("");
	}

	function Sentence(text)
	{
		var self = this;

		self.text = ko.observable(text);
	}
};


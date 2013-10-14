var Services = new function() {
	var self = this;

	self.viewModel = {				
		totalHours: ko.observable(0),
		editing: ko.observable(false),
		submitting: ko.observable(false),
		pageLoaded: ko.observable(false),
		rowsToRemove: [],
		semesters: [],
		semester: ko.observable(1),
		editable: ko.observable(true),

		add: function() {
			self.viewModel.services.push(new Service("", null, null));
			
			$('.datepick').datepicker({autoclose: true});			
		},

		remove: function(toRemove) {
			if (toRemove.dbid() != null)
				self.viewModel.rowsToRemove.push(toRemove);

			self.viewModel.services.remove(toRemove);
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

				var totalHours = self.viewModel.calculateTotalHours();

				$.ajax({
					type: "POST",
					url: '/saveServices',
					data: {
						services: ko.toJSON(self.viewModel.services()), 
						toRemove: ko.toJSON(self.viewModel.rowsToRemove),
						totalHours: totalHours
					},
					success: function(data) 
					{
						//alert('You earned ' + data.newbadgecount + ' new badges!');
						ko.mapping.fromJS(data.newservices, {}, self.viewModel.services);
						ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);					

						self.viewModel.originalServices = data.newservices;

						self.viewModel.rowsToRemove = [];
						self.viewModel.editing(false);
						self.viewModel.submitting(false);

						// Service specific stuff
						self.viewModel.totalHours(totalHours);
					},
					error: function() {alert('SaveClasses fail!');}
				});
			}
		},

		cancelEdit: function()
		{
			// Set back to original			
			ko.mapping.fromJS(self.viewModel.originalServices, {}, self.viewModel.services);

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

		calculateTotalHours: function()
		{
			var numServices = self.viewModel.services().length;
			var totalHours = 0;

			for(var i = 0; i < numServices; i++)
			{
				if (self.viewModel.services()[i].hours() != null)
					totalHours += parseInt(self.viewModel.services()[i].hours());
			}

			return totalHours;
		}
	};

	self.init = function() {
		self.viewModel.editing = ko.observable(false);

		var validationMapping = {
			hours: {
				create: function(options) {
					return ko.observable(options.data).extend({positiveNum:"Hours"});
				}
			},
			date: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			},
			name: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			}
		};

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/services/init',
				success: function(data) {					
					self.viewModel.services = ko.mapping.fromJS(data.userservices, validationMapping);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);					
					
					self.viewModel.originalServices = data.userservices;

					// Initialize Services specific stuff
					self.viewModel.totalHours(self.viewModel.calculateTotalHours());

					self.viewModel.semesters = data.semesters;
					self.viewModel.semester(data.init_semester);
					self.viewModel.editable(data.editable);

					self.viewModel.pageLoaded(true);
					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial activity load");}
			});
		});
	};

	// Subscribe to drop down change and update the UI accordingly
	self.viewModel.semester.subscribe(function(newValue) {
		if (self.viewModel.pageLoaded()){
			$.ajax({
				type: "POST",
				url: '/services/init',
				data: {semester: newValue},
				success: function(data) {				
					ko.mapping.fromJS(data.userservices, {}, self.viewModel.services);
					ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);
					self.viewModel.totalHours(self.viewModel.calculateTotalHours());							
					self.viewModel.editable(data.editable);
				},
				error: function() { alert("Failed drop down subscribe ajax post");}
			});
		}
	});

	function Service(name, date, hours)
	{
		var self = this;

		self.name = ko.observable(name).extend({required: ""});
		self.date = ko.observable(date).extend({required: ""});
		self.hours = ko.observable(hours).extend({positiveNum: "Hours"});
		self.dbid = ko.observable("");
	}
};
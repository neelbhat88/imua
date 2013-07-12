var Services = new function() {
	var self = this;

	self.viewModel = {		
		services: ko.observableArray(),
		totalHours: ko.observable(0),
		editing: ko.observable(false),
		rowsToRemove: [],	

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
			var totalHours = self.viewModel.calculateTotalHours();

			$.ajax({
				url: '/saveServices',
				data: {
					services: ko.toJSON(self.viewModel.services()), 
					toRemove: ko.toJSON(self.viewModel.rowsToRemove),
					totalHours: totalHours
				},
				success: function(data) 
				{
					//alert('You earned ' + data.newbadgecount + ' new badges!');
					self.viewModel.services = ko.mapping.fromJS(data.newservices);

					self.viewModel.originalServices = data.newservices;

					self.viewModel.rowsToRemove = [];
					self.viewModel.editing(false);

					// Service specific stuff
					self.viewModel.totalHours(totalHours);
				},
				error: function() {alert('SaveClasses fail!');}
			});		
		},

		cancelEdit: function()
		{
			// Set back to original
			self.viewModel.services = ko.mapping.fromJS(self.viewModel.originalServices);

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
		$(document).ready(function() {
			$.ajax({
				url: '/services',
				success: function(data) {					
					self.viewModel.services = ko.mapping.fromJS(data.userservices);
					self.viewModel.originalServices = data.userservices;

					// Initialize Services specific stuff
					self.viewModel.totalHours(self.viewModel.calculateTotalHours());

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial activity load");}
			});			

			ko.applyBindings(self.viewModel);

			// self.viewModel.services.push(new Service("Future Founders", '2012-02-01', 2));
			// self.viewModel.services.push(new Service("Habitat for Humanity", '2013-02-03', 5));			
		});
	};

	function Service(name, date, hours)
	{
		var self = this;

		self.name = ko.observable(name);
		self.date = ko.observable(date);
		self.hours = ko.observable(hours);		
		self.dbid = ko.observable("");
	}
};

// Add Badges for Service

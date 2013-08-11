var Pdus = new function() {
	var self = this;

	self.viewModel = {				
		editing: ko.observable(false),
		rowsToRemove: [],

		add: function() {
			self.viewModel.totalPdus.push(new Pdu(null, null));
			
			$('.datepick').datepicker({autoclose: true});
		},

		remove: function(toRemove) {
			if (toRemove.dbid() != null)
				self.viewModel.rowsToRemove.push(toRemove);

			self.viewModel.totalPdus.remove(toRemove);
		},	

		save: function()
		{		
			var hasErrors = false;
			$.each(self.viewModel.totalPdus(), function() {
				if (this.school_pdu_id() == null || this.date() == null || this.hours() == null)
				{
					hasErrors = true;
					return false; // Break out of the loop			
				}
			})

			if (hasErrors == true)
			{
				$('.validationError').fadeIn();
				$('.pdusEdit select, .pdusEdit input').each(function(){
					if (this.value == "")
						$(this).addClass('error');
					else
						$(this).removeClass('error');
				});
				return;
			}

			$.ajax({
				type: "POST",
				url: '/savePdus',
				data: {
					pdus: ko.toJSON(self.viewModel.totalPdus()), 
					toRemove: ko.toJSON(self.viewModel.rowsToRemove)
				},
				success: function(data) 
				{					
					ko.mapping.fromJS(data.newpdus, {}, self.viewModel.totalPdus);
					ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);					

					self.viewModel.originalPdus = data.newpdus;

					self.viewModel.rowsToRemove = [];
					self.viewModel.editing(false);					
				},
				error: function() {alert('SaveClasses fail!');}
			});		
		},

		cancelEdit: function()
		{
			// Set back to original			
			ko.mapping.fromJS(self.viewModel.originalPdus, {}, self.viewModel.totalPdus);

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
				url: '/pdus',
				success: function(data) {					
					self.viewModel.totalPdus = ko.mapping.fromJS(data.userpdus);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);					
					
					self.viewModel.originalPdus = data.userpdus;
					self.viewModel.globalpdus = ko.mapping.fromJS(data.globalpdus);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial activity load");}
			});
		});
	};

	function Pdu(date, hours)
	{
		var self = this;
		
		self.date = ko.observable(date);
		self.hours = ko.observable(hours);

		self.school_pdu_id = ko.observable("");
		self.dbid = ko.observable("");
	}
};

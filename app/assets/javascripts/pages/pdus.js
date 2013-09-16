var Pdus = new function() {
	var self = this;

	self.viewModel = {				
		editing: ko.observable(false),
		pageLoaded: ko.observable(false),
		rowsToRemove: [],
		semesters: [],
		semester: ko.observable(1),
		editable: ko.observable(true),

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
			if ($('select.error, input.error').length > 0)
			{
				$('.validationError').fadeIn();				
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

		var validationMapping = {
			hours: {
				create: function(options) {
					return ko.observable(options.data).extend({required: "", positiveNum:""});
				}
			},
			date: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			},
			school_pdu_id: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			}
		};

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/pdus',
				success: function(data) {					
					self.viewModel.totalPdus = ko.mapping.fromJS(data.userpdus, validationMapping);
					self.viewModel.badges = ko.mapping.fromJS(data.badges);					
					
					self.viewModel.originalPdus = data.userpdus;
					self.viewModel.globalpdus = ko.mapping.fromJS(data.globalpdus);

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
		$.ajax({
			type: "POST",
			url: '/pdus',
			data: {semester: newValue},
			success: function(data) {				
				ko.mapping.fromJS(data.userpdus, {}, self.viewModel.totalPdus);
				ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);
				self.viewModel.editable(data.editable);
			},
			error: function() { alert("Failed drop down subscribe ajax post");}
		});
	});

	function Pdu(date, hours)
	{
		var self = this;
		
		self.date = ko.observable(date).extend({required: ""});
		self.hours = ko.observable(hours).extend({required: "", positiveNum: ""});

		self.school_pdu_id = ko.observable("").extend({required: ""});
		self.dbid = ko.observable("");
	}	
};

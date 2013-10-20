$(function(){	
	Academics = function(user_id, isTeacher) {
		var self = this;

		self.UserId = user_id;
		self.IsTeacher = isTeacher;

		self.viewModel = {
			editing: ko.observable(false),
			submitting: ko.observable(false),
			rowsToRemove: [],
			pageLoaded: ko.observable(false),
			semesters: [],
			semester: ko.observable(1),
			editable: ko.observable(true)
		};

		// Subscribe to drop down change and update the UI accordingly
		self.viewModel.semester.subscribe(function(newValue) {
			if (self.viewModel.pageLoaded())
			{
				$.ajax({
					type: "POST",
					url: '/academics/init',
					data: {semester: newValue, user_id: self.UserId, isTeacher: self.IsTeacher},
					success: function(data) {
						ko.mapping.fromJS(data.userclasses, {}, self.viewModel.subjects);
						ko.mapping.fromJS(data.badges, {}, self.viewModel.badges);
						ko.mapping.fromJS(data.totalsemgpa, {}, self.viewModel.totalGPA)
						self.viewModel.editable(data.editable);
					},
					error: function() { alert("Failed drop down subscribe ajax post");}
				});
			}		
		});
	}

	Academics.prototype.init = function() {
		var self = this;

		var validationMapping = {
			grade: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			},			
			school_class_id: {
				create: function(options) {
					return ko.observable(options.data).extend({required: ""});
				}
			}
		};

		$(document).ready(function() {			
			$.ajax({
				type: "POST",
				url: '/academics/init',
				data: {user_id: self.UserId, isTeacher: self.IsTeacher},
				success: function(data) {
					var obj = data;
					self.viewModel.subjects = ko.mapping.fromJS(obj.userclasses, validationMapping);
					self.viewModel.badges = ko.mapping.fromJS(obj.badges);
					self.viewModel.totalGPA = ko.mapping.fromJS(obj.totalsemgpa);

					self.viewModel.originalSubjects = obj.userclasses;
					self.viewModel.globalsubjects = ko.mapping.fromJS(obj.globalclasses);					
					self.viewModel.semesters = obj.semesters;
					self.viewModel.semester(obj.init_semester);
					self.viewModel.editable(obj.editable);

					ViewModelPropertiesInit(self.viewModel, self);			

					self.viewModel.pageLoaded(true);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial badge load");}
			});
		});
	}	

	// This class has to match the ClassViewModel.rb definition
	function Class(name, classLevel, grade)
	{
		var self = this;

		self.name = ko.observable(name);
		self.level = ko.observable(classLevel);
		self.grade = ko.observable(grade).extend({required:""});
		self.school_class_id = ko.observable().extend({required:""});
		self.dbid = ko.observable("");
	}

	function ViewModelPropertiesInit(viewModel, thisObj)
	{
		var self = thisObj;
		
		viewModel.name = ko.observable().extend({editable: true});
		viewModel.classLevels = 
		[
			{levelid: 0, levelname: 'Regular'}, 
			{levelid: 1, levelname: 'Honors'},
			{levelid: 2, levelname: 'AP'}
		];

		viewModel.possibleGrades = ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F'];	
		viewModel.gpaHash = {
			'A':  4.0,  'A-': 3.67, 
			'B+': 3.33, 'B':  3.00, 'B-': 2.67, 
			'C+': 2.33, 'C':  2.00, 'C-': 1.67, 
			'D':  1.33, 
			'F':  1.0
		};		

		viewModel.addClass = function() {
			viewModel.subjects.push(new Class("", null, null));
		}

		viewModel.removeClass = function(classToRemove) {				
			if (classToRemove.dbid() != null)
				viewModel.rowsToRemove.push(classToRemove);

			viewModel.subjects.remove(classToRemove);
		}

		viewModel.saveClasses = function()
		{
			if (!viewModel.submitting())
			{			
				if ($('select.error, input.error').length > 0)
				{
					$('.validationError').fadeIn();				
					return;
				}

				viewModel.submitting(true);

				$.ajax({
					type: "POST",
					url: '/saveClasses',
					data: {
						classes: ko.toJSON(viewModel.subjects()), 
						classesToRemove: ko.toJSON(viewModel.rowsToRemove),
						semester: viewModel.semester,
						user_id: self.UserId,
					},
					success: function(data) 
					{				
						ko.mapping.fromJS(data.newclasses, {}, viewModel.subjects);
						ko.mapping.fromJS(data.badges, {}, viewModel.badges);
						ko.mapping.fromJS(data.totalsemgpa, {}, viewModel.totalGPA)

						viewModel.originalSubjects = data.newclasses;

						viewModel.rowsToRemove = [];				
						viewModel.editing(false);
						viewModel.submitting(false);
					},
					error: function() {alert('SaveClasses fail!');}
				});
			}
		}

		viewModel.cancelEdit = function()
		{
			// Set back to original subjects
			ko.mapping.fromJS(viewModel.originalSubjects, {}, viewModel.subjects);

			viewModel.rowsToRemove = [];
			viewModel.editing(false);
		}

		viewModel.editClasses = function()
		{		
			viewModel.editing(true);
		}

		viewModel.templateToUse = function()
		{
			return viewModel.editing() ? 'edit-classes' : 'view-classes';
		}	
	}
});
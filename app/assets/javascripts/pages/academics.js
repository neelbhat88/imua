var Academics = new function() {
	var self = this;

	self.viewModel = {
		pageLoaded: ko.observable(false)
	};

	self.init = function() {
		$(document).ready(function() {			
			$.ajax({
				type: "POST",
				url: '/academics',
				success: function(data) {
					var obj = data;
					self.viewModel.subjects = ko.mapping.fromJS(obj.userclasses);
					self.viewModel.originalSubjects = obj.userclasses;
					self.viewModel.globalsubjects = ko.mapping.fromJS(obj.globalclasses);
					self.viewModel.badges = ko.mapping.fromJS(obj.badges);
					self.viewModel.totalGPA = ko.mapping.fromJS(obj.totalsemgpa);

					ViewModelPropertiesInit(self.viewModel);			

					self.viewModel.pageLoaded(true);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial badge load");}
			});
		});
	};
};

// This class has to match the ClassViewModel.rb definition
function Class(name, classLevel, grade)
{
	var self = this;

	self.name = ko.observable(name);
	self.level = ko.observable(classLevel);
	self.grade = ko.observable(grade);
	self.school_class_id = ko.observable()
	self.dbid = ko.observable("");
}

function Badge(title, desc)
{
	var self = this;

	self.description = ko.observable(desc);
	self.title = ko.observable(title);
}

function ViewModelPropertiesInit(viewModel) 
{
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

	viewModel.editing = ko.observable(false);
	viewModel.rowsToRemove = [];

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
		var hasErrors = false;
		$.each(viewModel.subjects(), function() {
			if (this.school_class_id() == null || this.grade() == null)
			{
				hasErrors = true;
				return false; // Break out of the loop			
			}
		})

		if (hasErrors == true)
		{
			$('.validationError').fadeIn();
			$('.academicsEdit select, .academicsEdit input').each(function(){
					if (this.value == "")
						$(this).addClass('error');
					else
						$(this).removeClass('error');
				});		
			return;
		}			

		$.ajax({
			type: "POST",
			url: '/saveClasses',
			data: {
				classes: ko.toJSON(viewModel.subjects()), 
				classesToRemove: ko.toJSON(viewModel.rowsToRemove)
			},
			success: function(data) 
			{				
				viewModel.subjects = ko.mapping.fromJS(data.newclasses);
				ko.mapping.fromJS(data.badges, {}, viewModel.badges);
				ko.mapping.fromJS(data.totalsemgpa, {}, viewModel.totalGPA)

				viewModel.originalSubjects = data.newclasses;

				viewModel.rowsToRemove = [];				
				viewModel.editing(false);
			},
			error: function() {alert('SaveClasses fail!');}
		});		
	}

	viewModel.cancelEdit = function()
	{
		// Set back to original subjects
		viewModel.subjects = ko.mapping.fromJS(viewModel.originalSubjects);

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
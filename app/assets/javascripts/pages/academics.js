var Academics = new function() {
	var self = this;

	self.viewModel = {};

	self.init = function() {
		$(document).ready(function() {
			//ko.applyBindings(new ClassesViewModel());
			$.ajax({
				url: '/academics',
				success: function(data) {					
					self.viewModel.subjects = ko.mapping.fromJS(data.userclasses);
					self.viewModel.originalSubjects = data.userclasses;
					self.viewModel.globalsubjects = ko.mapping.fromJS(data.globalclasses);

					ViewModelPropertiesInit(self.viewModel);			

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed initial badge load");}
			});
		});
	};

	// self.initKOMapping = function () {
	// 	$.ajax({
	// 		url: '/academics',
	// 		success: function(data) {					
	// 			 var newData = ko.mapping.fromJS(data);
	// 			 self.viewModel.subjects(newData());
	// 			//ViewModelPropertiesInit(self.viewModel);			
	// 		},
	// 		error: function() { alert("Failed initial badge load");}
	// 	});
	// };
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

	viewModel.calculateTotalGpa = function() {
	//ko.computed(function(){
		var numClasses = viewModel.subjects().length;
		var nonNullClasses = 0;
		var fullGPA = 0;

		for (var i = 0; i < numClasses; i++)
		{
			if (viewModel.subjects()[i].grade() != null)
			{
				fullGPA += viewModel.gpaHash[viewModel.subjects()[i].grade()];
				nonNullClasses++;
			}
		}

		return fullGPA/nonNullClasses;
	}	

	viewModel.totalGPA = ko.observable(viewModel.calculateTotalGpa());

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
		var newGpa = viewModel.calculateTotalGpa();

		$.ajax({
			url: '/saveClasses',
			data: {
				totalGPA: newGpa, 
				classes: ko.toJSON(viewModel.subjects()), 
				classesToRemove: ko.toJSON(viewModel.rowsToRemove)
			},
			success: function(data) 
			{
				alert('You earned ' + data.newbadgecount + ' new badges!');
				viewModel.subjects = ko.mapping.fromJS(data.newclasses);

				viewModel.originalSubjects = data.newclasses;
				viewModel.totalGPA(newGpa);

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
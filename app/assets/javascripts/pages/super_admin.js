$(function(){
	SuperAdmin = function() {
		var self = this;

		self.viewModel = {
			sectionToShow: ko.observable("Math"),
			addingSubject: ko.observable(false),
			addingCategory: ko.observable(false),
			addingSubCategory: ko.observable(false),
			
			showSection: function(data, category)
			{
				if (category.toLowerCase() == self.viewModel.sectionToShow().toLowerCase())
					return true;

				return false;
			},

			clickSection: function(category)
			{
				self.viewModel.sectionToShow(category);
			},

			addSubject: function()
			{
				self.viewModel.addingSubject(true);
			},
			cancelSubject: function()
			{				
				self.viewModel.addingSubject(false);
				var $nameInput = $('#subjectNameInput');
				$nameInput.removeClass("error");
				$nameInput.val("");
			},
			saveSubject: function()
			{
				var $nameInput = $('#subjectNameInput');				

				if (!$nameInput.val())
				{
					$nameInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/subject",
					dataType: "json",
					data: {name: $nameInput.val()},
					success: function(subject){
						self.viewModel.addingSubject(false);
						$nameInput.removeClass("error");
						$nameInput.val("");

						// Add new subject to TestSubjects array
						self.viewModel.TestSubjects.push(ko.mapping.fromJS(subject));
					}
				});			
			},
			addCategory: function()
			{
				self.viewModel.addingCategory(true);
			},
			cancelCategory: function()
			{				
				self.viewModel.addingCategory(false);
				var $categoryInput = $('#categoryNameInput');
				var $categoryLevel = $('#categoryLevelInput');

				$categoryInput.removeClass("error");
				$categoryInput.val("");
				$categoryLevel.val("");
			},
			saveCategory: function(subject)
			{
				var $categoryInput = $('#categoryNameInput');
				var $categoryLevel = $('#categoryLevelInput');

				if (!$categoryInput.val())
				{
					$categoryInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/category",
					dataType: "json",
					data: {
						subjectName: subject.name(),
						name : $categoryInput.val(),
						level : $categoryLevel.val()
					},
					success: function(category){
						self.viewModel.addingCategory(false);
						$categoryInput.removeClass("error");
						$categoryInput.val("");
						$categoryLevel.val("");

						// Add new category to TestCategories array of the subject
						subject.TestCategories.push(ko.mapping.fromJS(category));
					}
				});			
			},
			addSubCategory: function()
			{
				self.viewModel.addingSubCategory(true);
			},
			cancelSubCategory: function()
			{				
				self.viewModel.addingSubCategory(false);
				var $subCategoryInput = $('#subCategoryInputs .name');
				$subCategoryInput.removeClass("error");

				$('#subCategoryInputs input').each(function(){
					$(this).val("");
				});				
			},
			saveSubCategory: function(category)
			{
				var $subCategoryInput = $('#subCategoryInputs .name');

				if (!$subCategoryInput.val())
				{
					$subCategoryInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/sub_category",
					data: {						
						categoryName: category.name(),
						name : $('#subCategoryInputs .name').val(),
						description: $('#subCategoryInputs .description').val(),
						level : $('#subCategoryInputs .level').val()
					},
					success: function(subCategory){
						self.viewModel.addingSubCategory(false);
						$subCategoryInput.removeClass("error");
						$('#subCategoryInputs input').each(function(){
							$(this).val("");
						});	

						// Add new subcategory to TestSubCategories array of the category
						category.TestSubCategories.push(ko.mapping.fromJS(subCategory));
					}
				});			
			}
		};
	}

	SuperAdmin.prototype.init = function(dataModel) {
		var self = this;

		ko.mapping.fromJS(dataModel, {}, self.viewModel);

		ko.applyBindings(self.viewModel);
	}
});
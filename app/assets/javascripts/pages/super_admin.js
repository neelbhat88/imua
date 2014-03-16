$(function(){
	SuperAdmin = function() {
		var self = this;

		self.viewModel = {
			sectionToShow: ko.observable("Math"),			
			
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
				$('#addSubjectModal').modal({backdrop: 'static'});
			},
			cancelSubject: function()
			{				
				$('#addSubjectModal').modal('hide');

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
						$('#addSubjectModal').modal('hide');
						$nameInput.removeClass("error");
						$nameInput.val("");

						// Add new subject to TestSubjects array
						self.viewModel.TestSubjects.push(ko.mapping.fromJS(subject));
					}
				});			
			},
			addCategory: function()
			{
				$('#addCategoryModal').modal({backdrop: 'static'});
			},
			cancelCategory: function()
			{				
				$('#addCategoryModal').modal('hide');
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
						$('#addCategoryModal').modal('hide');
						$categoryInput.removeClass("error");
						$categoryInput.val("");
						$categoryLevel.val("");

						// Add new category to TestCategories array of the subject
						subject.TestCategories.push(ko.mapping.fromJS(category));
					}
				});			
			},
			addSubCategory: function(category)
			{
				$('#addSubCategoryModal' + category.level()).modal({backdrop: 'static'});
			},
			cancelSubCategory: function(category)
			{				
				$('#addSubCategoryModal' + category.level()).modal('hide');
				var $subCategoryInput = $('#subCategoryInputs .name');
				$subCategoryInput.removeClass("error");

				$('#subCategoryInputs input').each(function(){
					$(this).val("");
				});				
			},
			saveSubCategory: function(category)
			{		
				var modal = '#addSubCategoryModal' + category.level();	
				var selector =  modal + ' #subCategoryInputs';
				var $subCategoryInputs = $(selector);
				var $nameInput = $subCategoryInputs.find('.name')
				var $descInput = $subCategoryInputs.find('.description')
				var $levelInput = $subCategoryInputs.find('.level')

				if (!$nameInput.val())
				{
					$nameInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/sub_category",
					data: {						
						categoryName: category.name(),
						name : $nameInput.val(),
						description: $descInput.val(),
						level : $levelInput.val()
					},
					success: function(subCategory){
						$(modal).modal('hide');
						$nameInput.removeClass("error");
						$subCategoryInputs.each(function(){
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

		$('#accordion').on('show.bs.collapse', function () {
	        $('#accordion .in').collapse('hide');
	    });
	}
});
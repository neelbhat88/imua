$(function(){
	SuperAdmin = function() {
		var self = this;

		self.viewModel = {
			sectionToShow: ko.observable("Math"),
			// ToDo: This is weird here, but is there a way to add these to just the subCategory observable objects?
			questionText: ko.observable(""),
			previewText: ko.observable(""),
			
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
			addCategory: function(subject)
			{
				$('#addCategoryModal' + subject.name()).modal({backdrop: 'static'});
			},
			cancelCategory: function(subject)
			{												
				var modal = '#addCategoryModal' + subject.name();
				var selector =  modal + ' .categoryInputs';
				var $categoryInputs = $(selector + " input");
				var $nameInput = $(selector + " input.name");

				$nameInput.removeClass("error");
				
				$categoryInputs.each(function(){
					$(this).val("");
				});

				$(modal).modal('hide');
			},
			saveCategory: function(subject)
			{
				var modal = '#addCategoryModal' + subject.name();
				var selector =  modal + ' .categoryInputs';
				var $categoryInputs = $(selector + " input");
				var $nameInput = $(selector + " input.name");
				var $levelInput = $(selector + " input.level");

				if (!$nameInput.val())
				{
					$nameInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/category",
					dataType: "json",
					data: {
						subjectName: subject.name(),
						name : $nameInput.val(),
						level : $levelInput.val()
					},
					success: function(category){						
						$nameInput.removeClass("error");						
						$categoryInputs.each(function(){
							$(this).val("");
						});

						$(modal).modal('hide');

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
				var modal = '#addSubCategoryModal' + category.level();	
				var selector =  modal + ' .subCategoryInputs';
				var $subCategoryInputs = $(selector + " input");
				var $nameInput = $(selector + " input.name");
				
				$nameInput.removeClass("error");

				$subCategoryInputs.each(function(){
					$(this).val("");
				});				

				$(modal).modal('hide');
			},
			saveSubCategory: function(category)
			{		
				var modal = '#addSubCategoryModal' + category.level();	
				var selector =  modal + ' .subCategoryInputs';
				var $subCategoryInputs = $(selector + " input");
				var $nameInput = $(selector + " input.name");
				var $descInput = $(selector + " input.description");
				var $levelInput = $(selector + " input.level");

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
						$nameInput.removeClass("error");
						$subCategoryInputs.each(function(){
							$(this).val("");
						});	

						$(modal).modal('hide');

						// Add new subcategory to TestSubCategories array of the category
						category.TestSubCategories.push(ko.mapping.fromJS(subCategory));
					}
				});			
			},
			addQuestion: function(subCategory)
			{
				$('#addQuestionModal' + subCategory.id()).modal({backdrop: 'static'});

				self.viewModel.previewText("");
				self.viewModel.questionText("");
			},
			saveQuestion: function(subCategory)
			{				
				var modal = '#addQuestionModal' + subCategory.id();
				var selector =  modal + ' .questionInputs';				
				var $questionInputs = $(selector + " input, " + selector + " textarea");
				var $questionTextInput = $(selector + " textarea.questionText");
				var $solutionUrlInput = $(selector + " input.solutionUrl");

				
				if (!$questionTextInput.val())
				{
					$questionTextInput.addClass("error");
					return false;
				}
					
				$.ajax({
					type: "POST",
					url: "/super_admin/test_prep/question",
					data: {						
						subCategoryName: subCategory.name(),
						questionText : $questionTextInput.val(),
						solutionUrl : $solutionUrlInput.val()
					},
					success: function(question)
					{
						self.viewModel.cancelQuestion(subCategory);

						// Add new subcategory to TestSubCategories array of the category
						subCategory.TestQuestions.push(ko.mapping.fromJS(question));

						MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
					}
				});
			},
			cancelQuestion: function(subCategory)
			{				
				var modal = '#addQuestionModal' + subCategory.id();
				var selector =  modal + ' .questionInputs';
				var $questionInputs = $(selector + " input, " + selector + " textarea");
				
				$questionInputs.removeClass("error");

				self.viewModel.previewText("");
				self.viewModel.questionText("");
				$questionInputs.each(function(){
					$(this).val("");
				});

				$(modal).modal('hide');
			},
			updateQuestionPreview: function()
			{
				self.viewModel.previewText(self.viewModel.questionText());
				MathJax.Hub.Queue(["Typeset",MathJax.Hub]);

				return true;
			}
		};
	}

	SuperAdmin.prototype.init = function(dataModel) {
		var self = this;

		ko.mapping.fromJS(dataModel, {}, self.viewModel);

		ko.applyBindings(self.viewModel);

		new Accordion().init();
	}

	function Question(subCategoryId){
		var self = this;
		
		self.subCategoryId = subCategoryId;
		self.questionText = ko.observable("");
		self.solutionUrl = ko.observable("");		
	}
});
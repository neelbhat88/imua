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
		};
	}

	SuperAdmin.prototype.init = function(dataModel) {
		var self = this;

		ko.mapping.fromJS(dataModel, {}, self.viewModel);

		ko.applyBindings(self.viewModel);
	}
});
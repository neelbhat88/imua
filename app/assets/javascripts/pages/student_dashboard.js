$(function(){
	StudentDashboard = function() 
	{
		var self = this;

		self.viewModel = {

		}
	}

	StudentDashboard.prototype.init = function(dataModel) 
	{
		var self = this;

		ko.mapping.fromJS(dataModel, {}, self.viewModel);

		ko.applyBindings(self.viewModel);
	}
});
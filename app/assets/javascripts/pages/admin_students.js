$(function(){
	AdminStudents = function(progressPageUrl) 
	{
		var self = this;
		
		self.ProgressPageUrl = progressPageUrl;

		new Header().SetSelectedMenuItem('AdminStudents');

		self.viewModel = {
			pageLoaded: ko.observable(false),

			viewCategory: function(user, selectedDiv) {
				var page = selectedDiv.title;

				var url = self.ProgressPageUrl + "?id=" + user.id() + "&page=" + page;
				window.location = url;
			}
		};
	}

	AdminStudents.prototype.init = function() {
		var self = this;

		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/admin/students/init',
				success: function(data) {
					// ToDo: Do This better!
					self.viewModel.students2016 = ko.mapping.fromJS(data.students2016);
					self.viewModel.students2017 = ko.mapping.fromJS(data.students2017);

					self.viewModel.pageLoaded(true);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed to load admin/students. Please refresh page.");}
			});
		});
	}
});
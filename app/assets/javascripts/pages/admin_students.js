$(function(){
	AdminStudents = function(progressPageUrl) 
	{
		var self = this;
		
		self.ProgressPageUrl = progressPageUrl;

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
					self.viewModel.students = ko.mapping.fromJS(data.students);

					self.viewModel.pageLoaded(true);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed to load admin/students. Please refresh page.");}
			});
		});
	}
});
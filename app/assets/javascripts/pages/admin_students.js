var AdminStudents = new function() {
	var self = this;

	self.viewModel = {
		pageLoaded: ko.observable(false),
	};

	self.init = function() {
		$(document).ready(function() {
			$.ajax({
				type: "POST",
				url: '/admin/students',
				success: function(data) {					
					self.viewModel.students = ko.mapping.fromJS(data.students);

					self.viewModel.pageLoaded(true);

					ko.applyBindings(self.viewModel);
				},
				error: function() { alert("Failed to load admin/students. Please refresh page.");}
			});
		});
	};	
}
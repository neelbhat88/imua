// var SchoolClasses = new function() {
// 	var self = this;

// 	self.viewModel = {};

// 	self.init = function() {
// 		$(document).ready(function() {
// 			//ko.applyBindings(new ClassesViewModel());
// 			$.ajax({
// 				url: '/academics',
// 				success: function(data) {					
// 					self.viewModel.subjects = ko.mapping.fromJS(data);
// 					self.viewModel.originalSubjects = data;

// 					ViewModelPropertiesInit(self.viewModel);			

// 					ko.applyBindings(self.viewModel);
// 				},
// 				error: function() { alert("Failed initial badge load");}
// 			});			
// 		});
// 	};
// };
$(function() {
	Progress = function(user_id, category, isTeacher) {
		var self = this;

		self.UserId = user_id == 0 ? "" : user_id;
		self.Category = category == 0 ? "" : category;
		self.IsTeacher = isTeacher;

		new Header().SetSelectedMenuItem('Progress');
	}

	Progress.prototype.init = function() {
		var self = this;
		
		$(document).ready(function() {						
			$('#academicsNav').click(function(){
				$('#progressPages').load("/academics", function(){
					new Academics(self.UserId, self.IsTeacher).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});

			$('#extracurNav').click(function(){
				$('#progressPages').load("/activities", function() {
					new Activities(self.UserId, self.IsTeacher).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");		
			});

			$('#serviceNav').click(function(){
				$('#progressPages').load("/services", function() {
					new Services(self.UserId, self.IsTeacher).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");			
			});

			$('#pduNav').click(function(){
				$('#progressPages').load("/pdus", function() {
					new Pdus(self.UserId, self.IsTeacher).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});

			$('#testingNav').click(function(){
				$('#progressPages').load("/testing", function() {
					new Testing(self.UserId, self.IsTeacher).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});

			// Load page that was clidked on
			switch (self.Category.toLowerCase())
			{
				case "academics":
					$('#academicsNav').trigger('click');
					break;
				case "extracurricular":
					$('#extracurNav').trigger('click');
					break;
				case "service":
					$('#serviceNav').trigger('click');
					break;
				case "pdu":
					$('#pduNav').trigger('click');
					break;
				case "testing":
					$('#testingNav').trigger('click');
					break;
				default:
					$('#academicsNav').trigger('click');
					break;
			}
		});
	}
});
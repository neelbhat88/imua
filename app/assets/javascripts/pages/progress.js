$(function() {
	Progress = function(user_id, category) {
		var self = this;

		self.UserId = user_id == 0 ? "" : user_id;
		self.Category = category == 0 ? "" : category;

		new Header().SetSelectedMenuItem('Progress');
	}

	Progress.prototype.init = function() {
		$(document).ready(function() {
			// Load Academics page as default
			$('#progressPages').load("/academics", function(){
				new Academics(self.UserId, self.Category).init();

				$('#academicsNav').addClass("selected");
			});

			$('#academicsNav').click(function(){
				$('#progressPages').load("/academics", function(){
					new Academics(self.UserId, self.Category).init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});

			$('#extracurNav').click(function(){
				$('#progressPages').load("/activities", function() {
					Activities.init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");		
			});

			$('#serviceNav').click(function(){
				$('#progressPages').load("/services", function() {
					Services.init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");			
			});

			$('#pduNav').click(function(){
				$('#progressPages').load("/pdus", function() {
					Pdus.init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});

			$('#testingNav').click(function(){
				$('#progressPages').load("/testing", function() {
					Testing.init();
				});

				$('.progressNav li').removeClass("selected");
				$(this).addClass("selected");
			});
		});
	}
});
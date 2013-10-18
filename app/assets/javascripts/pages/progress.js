$(function() {
	Progress = function() {
		var self = this;

		new Header().SetSelectedMenuItem('Progress');
	}

	Progress.prototype.init = function() {
		$(document).ready(function() {			
			// Load Academics page as default
			$('#progressPages').load("/academics", function(){
				Academics.init();

				$('#academicsNav').addClass("selected");
			});			

			$('#academicsNav').click(function(){
				$('#progressPages').load("/academics", function(){
					Academics.init();
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
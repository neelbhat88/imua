var Progress = new function() {
	var self = this;	
	
	self.init = function() {
		$(document).ready(function() {			
			// Load Academics page as default
			$('#progressPages').load("/academics", function(){
				Academics.init();
			});			

			$('#academicsNav').click(function(){
				$('#progressPages').load("/academics", function(){
					Academics.init();
				});				
			});

			$('#extracurNav').click(function(){
				$('#progressPages').load("/activities", function() {
					Activities.init();
				});				
			});

			$('#serviceNav').click(function(){
				$('#progressPages').load("/services", function() {
					Services.init();
				});				
			});

			$('#pduNav').click(function(){
				$('#progressPages').load("/academics", function() {
					Academics.init();
				});				
			});
		});
	};	
};
var Header = new function() {
	var self = this;

	self.init = function(page) {
		// Set the selected page in the navigation menu
		var navItem = ".nav > li[page='" + page + "']";
		$(".nav > li").removeClass("selected");
		$(navItem).addClass("selected");		
	};	
}
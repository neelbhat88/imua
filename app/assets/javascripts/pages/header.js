$(function() {
	Header = function() {
		var self = this;
	}

	Header.prototype.SetSelectedMenuItem = function(page) {
		// Set the selected page in the navigation menu
		var navItem = ".nav > li[page='" + page + "']";
		$(".nav > li").removeClass("active");
		$(navItem).addClass("active");
	};
});
var Header = new function() {
	var self = this;

	self.init = function(page) {
		// Set the selected page in the navigation menu
		var navItem = ".nav > li[page='" + page + "']";
		$(".nav > li").removeClass("selected");
		$(navItem).addClass("selected");

		$(document).ready(function() {
			// Adjust leftpanel size			
			$(window).resize(function() {
				self.setPageContainerHeight();
			});
		});		
	};	

	self.setPageContainerHeight = function()
	{
		if (window.innerHeight > $('.pageContainer').height() + $('#mynav').height())
		{
			var height = window.innerHeight - $('#mynav').height();
			$('.pageContainer').height(height);
		}
		else
		{
			$('.pageContainer').height('100%');
		}
	}
}
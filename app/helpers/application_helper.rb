module ApplicationHelper

	def title
	  if @title
	    "#{@title}"
	  elsif controller_name == 'static_pages'
	    "Waianae Coast Scholarship Fund | #{action_name.capitalize}"
	  else
	  	"Waianae Coast Scholarship Fund"
	  end
	end

end

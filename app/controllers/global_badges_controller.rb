class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!
	
	def index		
		semester = params[:semester]

		# ToDo: Create a separate model here that gets returned to the view with more information
		# that is necessary to display the view
		allbadges = GlobalBadge.all

		if !semester.nil? || !semester.to_s.empty?
			allbadges = GlobalBadge.where('semester = ?', semester)
		end

		respond_to do |format|
			format.json { render :json => allbadges }
			format.html # index.html.erb
		end
	end

	def new
		@badge = GlobalBadge.new
	end
end

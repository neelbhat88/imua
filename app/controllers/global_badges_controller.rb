class GlobalBadgesController < ApplicationController
	def index
		semester = params[:semester]

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

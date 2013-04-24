class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index		
		semester = params[:semester]

		allbadges = GlobalBadge.all

		if !semester.nil? || !semester.to_s.empty?
			allbadges = GlobalBadge.where('semester = ?', semester)
		end

		badgesviewmodel = []
		allbadges.each do | ab |
			hasEarned = false
			
			if current_user.user_badges.find_by_global_badge_id(ab.id) != nil
				hasEarned = true
			end

			badgesviewmodel << BadgeViewModel.new(ab, hasEarned)
		end

		respond_to do |format|
			format.json { render :json => badgesviewmodel }
			format.html # index.html.erb
		end
	end

	def new
		@badge = GlobalBadge.new
	end
end

class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index		
		semester = params[:semester]
		if semester.nil? || !semester.to_s.empty?
			semester = current_user.user_info.current_semester
		end

		allbadges = GlobalBadge.where('semester = ?', semester)		

		badgesviewmodel = []
		allbadges.each do | ab |
			hasEarned = false
			
			if current_user.user_badges.find_by_global_badge_id(ab.id) != nil
				hasEarned = true
			end

			badgesviewmodel << BadgeViewModel.new(ab, hasEarned)
		end

		# ToDo - If user hasn't earned all min reqs do we return all badges?
		badgesearned = current_user.user_badges.length

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel, 
										   :badgesearned => badgesearned } }
			format.html # index.html.erb
		end
	end

	def new
		@badge = GlobalBadge.new
	end
end

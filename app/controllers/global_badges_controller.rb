class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index				
		semester = current_user.user_info.current_semester		

		allbadges = GlobalBadge.where('semester = ?', semester)
		logger.debug("Debug: Loading badges for semester #{semester}")

		badgesviewmodel = GetBadgesViewModel(allbadges)

		# ToDo - If user hasn't earned all min reqs do we return all badges?
		badgesearned = current_user.user_badges.length

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel, 
										   :badgesearned => badgesearned ,
										   :semester => current_user.user_info.current_semester} }
			format.html # index.html.erb
		end
	end

	def new
		@badge = GlobalBadge.new
	end

	def progress
	end

	def SemesterBadges
		semester = params[:semester]
		if semester.nil? || semester.to_s.empty?
			semester = current_user.user_info.current_semester
		end

		allbadges = GlobalBadge.where('semester = ?', semester)
		logger.debug("Debug: Loading badges for semester #{semester}")

		badgesviewmodel = GetBadgesViewModel(allbadges)

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel }}
		end
	end

private
	def GetBadgesViewModel(allbadges)
		badgesviewmodel = []
		allbadges.each do | ab |
			hasEarned = false
			
			if current_user.user_badges.find_by_global_badge_id(ab.id) != nil
				hasEarned = true
			end

			badgesviewmodel << BadgeViewModel.new(ab, hasEarned)
		end

		return badgesviewmodel
	end

end

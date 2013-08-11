class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index				
		semester = current_user.user_info.current_semester		

		allbadges = GlobalBadge.where('semester = ?', semester)
		logger.debug("Debug: Loading badges for semester #{semester}")

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user)
		
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

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user)

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel }}
		end
	end

private
	def GetSemesterBadgesEarned(semester)		
		if (current_user.user_info.MetAllMinRequirements())
			return current_user.user_badges.where(:semester => semester).length
		end
	end

end

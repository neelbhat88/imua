class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index		
	end

	def init
		semester = current_user.user_info.current_semester		

		allbadges = GlobalBadge.where(:semester => [nil, semester])
		logger.debug("Debug: Loading badges for semester #{semester}")

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user, semester)
		
		badgesearned = 0
		badgesviewmodel.each do | b |
			if b.hasEarned == "Yes"
				badgesearned += 1
			end
		end

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

		allbadges = GlobalBadge.where(:semester => [nil, semester])

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user, semester)

		badgesearned = 0
		badgesviewmodel.each do | b |
			if b.hasEarned == "Yes"
				badgesearned += 1
			end
		end

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel, :badgesearned => badgesearned }}
		end
	end

private
	

end

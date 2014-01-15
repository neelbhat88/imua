class GlobalBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index		
	end

	def init
		semester = current_user.user_info.current_semester		

		allbadges = GlobalBadgeRepository.new().LoadAllBadges(semester)
		logger.debug("Debug: Loading badges for semester #{semester}")

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user, semester)		
		badgesearned = GlobalBadge.GetNumBadgesEarned(current_user, semester)
		minreqsmet = current_user.user_info.MetAllMinRequirements(semester)

		totalBadgesValue = 0
		#if (minreqsmet)			
			badges = badgesviewmodel.select{|b| b.hasEarned == 'Yes'}
			badges.each do |b|
				totalBadgesValue += b.badgeValue
			end
		#end

		respond_to do |format|
			format.json { render :json => {:badges => badgesviewmodel, 
										   :badgesearned => badgesearned ,
										   :minreqsmet => minreqsmet,
										   :totalbadgevalue => totalBadgesValue,
										   :semester => current_user.user_info.current_semester} }
			format.html # index.html.erb
		end
	end

	def new
		@badge = GlobalBadge.new
	end

	def progress
		@category = params[:page].to_s == "" ? "academics" : params[:page].to_s		
	end

	def SemesterBadges
		semester = params[:semester].to_i
		if semester == 0
			semester = current_user.user_info.current_semester
		end

		allbadges = GlobalBadgeRepository.new().LoadAllBadges(semester)

		badgesviewmodel = GlobalBadge.GetBadgesViewModel(allbadges, current_user, semester)
		badgesearned = GlobalBadge.GetNumBadgesEarned(current_user, semester)
		minreqsmet = current_user.user_info.MetAllMinRequirements(semester)

		totalBadgesValue = 0
		#if (minreqsmet)			
			badges = badgesviewmodel.select{|b| b.hasEarned == 'Yes'}
			badges.each do |b|
				totalBadgesValue += b.badgeValue
			end
		#end

		respond_to do |format|
			format.json { render :json => { :badges => badgesviewmodel, 
											:minreqsmet => minreqsmet,
										    :totalbadgevalue => totalBadgesValue,
											:badgesearned => badgesearned 
										  }
						}
		end
	end

private
	

end

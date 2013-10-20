class BadgeProcessor
	attr_accessor :curr_user
	
	def initialize(user, semester)
		@badgefactory = BadgeFactory.new(user)
		@curr_user = user
		@semester = semester
	end

	def CheckSemesterAcademics
		return CompareBadges(@badgefactory.GetAcademicsBadges(@semester))
	end

	def CheckSemesterActivities		
		return CompareBadges(@badgefactory.GetActivitiesBadges(@curr_user.user_info.current_semester))
	end

	def CheckSemesterServices
		return CompareBadges(@badgefactory.GetServicesBadges(@curr_user.user_info.current_semester))
	end

	def CheckSemesterPdus
		return CompareBadges(@badgefactory.GetPduBadges(@curr_user.user_info.current_semester))
	end

	def CheckSemesterTesting
		return CompareBadges(@badgefactory.GetTestingBadges(@curr_user.user_info.current_semester))
	end

	def CompareBadges(allBadges)
		newbadgecount = 0
		badgesearned = []
		badgeslost = []
	  	allBadges.each do |b|
	  		# If badge is not minreq then only compare if all minreqs met
	  		badgeEarned = false
	  		
	  		badgeEarned = b.Compare()	  			
	  		Rails.logger.debug("DEBUG: #{b.description} earned? #{badgeEarned}")

	  		userHasBadge = (@curr_user.user_badges.where(:global_badge_id => b.id, :semester => @semester).length > 0)
	  		Rails.logger.debug("DEBUG: User has badge Sem: #{@semester} Badge: #{b.id} - #{b.description}? #{userHasBadge}")

	  		# If badge earned and user does not have badge
	  		if badgeEarned == true && userHasBadge == false
	  			newbadgecount += 1
	  			badgesearned << b

	  			# Save earned badge to db
	  			@curr_user.user_badges.create(:global_badge_id => b.id, :semester => @semester)
	  		
	  		# If badge not earned and user has badge
	  		elsif badgeEarned == false && userHasBadge == true
	  			removedBadge = @curr_user.user_badges.find_by_global_badge_id(b.id)
	  			badgeslost << b

	  			# Remove earned badge
	  			@curr_user.user_badges.find_by_global_badge_id(b.id).destroy()
	  			Rails.logger.debug("DEBUG: BadgeEarned = false and UserHasBadge = true. UserBadge with GlobalBadgeId: #{b.id} removed.")
	  		end
	  	end
	  	
	  	#return newbadgecount
	  	return :badgesEarned => badgesearned, :badgesLost => badgeslost
	end
end
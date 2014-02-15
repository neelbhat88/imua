class BadgeProcessor
	attr_accessor :badgefactory
	
	def initialize(badgefactory=BadgeFactory.new)
		@badgefactory = badgefactory		
	end

	def CheckSemesterAcademics(user, semester)
		return CompareBadges(user, semester, @badgefactory.GetBadges(:user => user, :semester => semester, :category => "Academics"))
	end

	def CheckSemesterActivities(user, semester)
		return CompareBadges(user, semester, @badgefactory.GetBadges(:user => user, :semester => semester, :category => "Activity"))
	end

	def CheckSemesterServices(user, semester)		
		return CompareBadges(user, semester, @badgefactory.GetBadges(:user => user, :semester => semester, :category => "Service"))
	end

	def CheckSemesterPdus(user, semester)		
		return CompareBadges(user, semester, @badgefactory.GetBadges(:user => user, :semester => semester, :category => "PDU"))
	end

	def CheckSemesterTesting(user, semester)		
		return CompareBadges(user, semester, @badgefactory.GetBadges(:user => user, :semester => semester, :category => "Testing"))
	end

	def CheckSemesterTestingPracticeTests(user, semester)		
		return CompareBadges(user, semester, @badgefactory.GetTestingPracticeTestBadges(:user => user, :semester => semester))
	end

	private
	def CompareBadges(user, semester, allBadges)
		badgesearned = []
		badgeslost = []
	  	allBadges.each do |b|
	  		badgeEarned = false
	  		
	  		badgeEarned = b.Compare()	  			
	  		Rails.logger.debug("DEBUG: #{b.description} earned? #{badgeEarned}")

	  		userHasBadge = b.HasEarned()
	  		Rails.logger.debug("DEBUG: User has badge Sem: #{semester} Badge: #{b.id} - #{b.description}? #{userHasBadge}")

	  		# If badge earned and user does not have badge
	  		if badgeEarned == true && userHasBadge == false
	  			badgesearned << b

	  			# Save earned badge to db
	  			user.user_badges.create(:global_badge_id => b.id, :semester => semester)
	  		
	  		# If badge not earned and user has badge
	  		elsif badgeEarned == false && userHasBadge == true	  			
	  			badgeslost << b

	  			# Remove earned badge
	  			#user.user_badges.where(:global_badge_id => b.id, :semester => semester).destroy_all()
	  			b.user_badge.destroy_all()
	  			Rails.logger.debug("DEBUG: BadgeEarned = false and UserHasBadge = true. UserBadge with GlobalBadgeId: #{b.id} removed.")
	  		end
	  	end
	  	
	  	return :badgesEarned => badgesearned, :badgesLost => badgeslost
	end
end
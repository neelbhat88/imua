class BadgeProcessor
	attr_accessor :curr_user
	
	def initialize(user)
		@badgefactory = BadgeFactory.new(user)
		@curr_user = user
	end

	def CheckSemesterAcademics
		allBadges = @badgefactory.GetAcademicsBadges(@curr_user.user_info.current_semester)		

	  	# Call compare and pass in totalGPA
	  	newbadgecount = 0
	  	allBadges.each do |b|
	  		if b.Compare() == true && @curr_user.user_badges.find_by_global_badge_id(b.id) == nil
	  			newbadgecount += 1

	  			# Save earned badge to db
	  			@curr_user.user_badges.create(:global_badge_id => b.id)
	  		end
	  	end

	  	return newbadgecount
	end
end
class UserBadgeRepository
	def initialize()
	end

	def HasEarnedGlobalBadge(userId, globalBadgeId, semester=nil)
		if semester.nil?
			return UserBadge.where(:user_id=>userId, :global_badge_id => globalBadgeId).length != 0
		else
			return UserBadge.where(:user_id=>userId, :semester => semester, :global_badge_id => globalBadgeId).length != 0
		end		
	end

	def GetUserBadge(userId, globalBadgeId, semester=nil)
		if semester.nil?
			return UserBadge.where(:user_id=>userId, :global_badge_id => globalBadgeId)
		else
			return UserBadge.where(:user_id=>userId, :semester => semester, :global_badge_id => globalBadgeId)
		end
	end

	def GetScholarshipPointsEarned(user, semester=nil)		
		if semester.nil?
			return user.user_badges.joins(:global_badge).sum(:badge_value)
		end
		
		# If semester is passed in need to do some extra stuff since certain badges can be earned in a different semester than the one
		# defined by the global_badge (TestingPrepQuiz is an example)
		badges = user.user_badges.includes(:global_badge).where("user_badges.semester = ?", semester)		
		earnedBadges = badges.select{|b| b.global_badge.semester == nil || b.semester == b.global_badge.semester}

		pointsEarned = 0
		earnedBadges.each do |b|
			pointsEarned += b.global_badge.badge_value
		end

		return pointsEarned
	end
end
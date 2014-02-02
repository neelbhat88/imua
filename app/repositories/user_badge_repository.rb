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
end
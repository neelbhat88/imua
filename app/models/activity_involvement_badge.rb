class ActivityInvolvementBadge < ActivityBadge	

	def initialize(globalbadge, user)
		# call ActivityBadge contructor
		super	
	end

	def Compare()
		if (self.curr_user.user_activities.length >= self.comparevalue.to_i)
			return true
		end

	    return false
	end
end
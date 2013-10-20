class ActivitiesLeadershipBadge < ActivitiesBadge	

	def initialize(globalbadge, user, semester)
		# call ActivityBadge contructor
		super
	end

	def Compare()
		if (self.curr_user.user_activities.where('semester = ? and leadership_held = true',
				self.semester).length >= self.comparevalue.to_i)
			return true
		end

	    return false
	end
end
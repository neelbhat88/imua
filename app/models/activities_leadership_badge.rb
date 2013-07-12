class ActivitiesLeadershipBadge < ActivitiesBadge	

	def initialize(globalbadge, user)
		# call ActivityBadge contructor
		super	
	end

	def Compare()
		if (self.curr_user.user_activities.where('current_semester = ? and leadership_held = true', 
				self.curr_user.user_info.current_semster).length >= self.comparevalue.to_i)
			return true
		end

	    return false
	end
end
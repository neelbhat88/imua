class ActivitiesInvolvementBadge < ActivitiesBadge
	attr_accessor :subcategory
	
	def initialize(globalbadge, user, semester)
		# call ActivityBadge contructor
		super

		self.subcategory = globalbadge.subcategory
	end

	def Compare()
		if (self.curr_user.user_activities.where("semester = ?", 
				self.semester).length >= self.comparevalue.to_i)
			return true
		end

	    return false
	end
end
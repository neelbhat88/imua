class AcademicsGpaBadge < AcademicsBadge
	attr_accessor :comparevalue, :curr_user, :id

	def initialize(globalbadge, user)
		@comparevalue = globalbadge.comparevalue.to_f
		@curr_user = user
		@id = globalbadge.id
	end

	def Compare()
		if (@curr_user.user_info.GetTotalGpa >= @comparevalue)
	      return true
	    end

	    return false
	end
end
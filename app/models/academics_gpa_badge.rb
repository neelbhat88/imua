class AcademicsGpaBadge < AcademicsBadge
	attr_accessor :gpa

	def initialize(globalbadge, user)
		# call AcademicsBadge contructor
		super

		self.gpa = globalbadge.comparevalue.to_f		
	end

	def Compare()
		if (self.curr_user.user_info.GetTotalGpa() >= self.gpa)
			return true
		end		

	    return false
	end
end
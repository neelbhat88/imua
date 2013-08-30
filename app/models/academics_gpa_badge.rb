class AcademicsGpaBadge < AcademicsBadge
	attr_accessor :gpa

	def initialize(globalbadge, user)
		# call AcademicsBadge contructor
		super

		self.gpa = globalbadge.comparevalue.to_f		
	end

	def Compare()
		Rails.logger.debug("*******************DEBUG: Current gpa = #{self.curr_user.user_semester_gpas.where(:semester => self.curr_user.user_info.current_semester).first.gpa}. Compared to: #{self.gpa}")
		if (self.curr_user.user_semester_gpas.where(:semester => self.curr_user.user_info.current_semester).first.gpa >= self.gpa)
			return true
		end		

	    return false
	end
end
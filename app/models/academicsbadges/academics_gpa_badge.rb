class AcademicsGpaBadge < AcademicsBadge
	attr_accessor :gpa, :subcategory

	def initialize(globalbadge, user, semester)
		# call AcademicsBadge contructor
		super

		self.subcategory = globalbadge.subcategory
		self.gpa = globalbadge.comparevalue.to_f
	end

	def Compare()
		if (self.curr_user.user_semester_gpas.where(:semester => self.semester).first.gpa >= self.gpa)
			return true
		end		

	    return false
	end
end
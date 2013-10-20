class AcademicsGradeBadge < AcademicsBadge
	attr_accessor :comparegrade, :compareclass

	def initialize(globalbadge, user, semester)
		# call AcademicsBadge contructor
		super

		self.comparegrade = globalbadge.comparevalue.split("|")[0] # First part is LetterGrade
		self.compareclass = globalbadge.comparevalue.split("|")[1].to_i # Second part is SchoolClassId
	end

	def Compare()
		if (self.curr_user.user_classes.where("grade = ? and school_class_id = ? and semester = ?", 
				self.comparegrade, 
				self.compareclass, 
				self.semester).length > 0)
	      return true
	    end

	    return false
	end
end
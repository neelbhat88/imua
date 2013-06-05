class AcademicsGradeBadge < AcademicsBadge
	attr_accessor :comparegrade, :compareclass, :curr_user, :id

	def initialize(globalbadge, user)
		@comparegrade = globalbadge.comparevalue.split("|")[0] # First part is LetterGrade
		@compareclass = globalbadge.comparevalue.split("|")[1].to_i # Second part is SchoolClassId
		@curr_user = user
		@id = globalbadge.id
	end

	def Compare()
		#if (@curr_user.user_info.GetTotalGpa >= @comparevalue)
# Do this
#@curr_user.user_classes.where("grade = ? and school_class_id = ? and semester = ?")
	    #  return true
	    #end

	    return false
	end
end
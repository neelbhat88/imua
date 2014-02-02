class AcademicsClassCreditBadge < AcademicsBadge
	attr_accessor :schoolclassid, :subcategory

	def initialize(globalbadge, user)
		# call AcademicsBadge contructor
		super

		self.subcategory = globalbadge.subcategory
		self.schoolclassid = globalbadge.comparevalue.to_i
	end

	def Compare()
		# ENTER Class Credit Badge and test this!
		
		# If user has class with schoolclassid then credit given
		if (self.curr_user.user_classes.where('semester = ? and school_class_id = ?',
					self.curr_user.user_info.current_semster,
					self.schoolclassid).length > 0)
			return true
		end		

	    return false
	end
end
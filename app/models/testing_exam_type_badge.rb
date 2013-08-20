class TestingExamTypeBadge < TestingBadge
	attr_accessor :globalexamtype, :count

	def initialize(globalbadge, user)
		# call ActivityBadge contructor
		super

		self.globalexamtype = globalbadge.comparevalue.split("|")[0] # First part is Global Exam Type
		self.count = globalbadge.comparevalue.split("|")[1].to_i # Second part is count
	end

	def Compare()
		user_type_badges = self.curr_user.user_testings.joins(:global_exam).where("global_exams.exam_type=? and user_testings.semester= ?", self.globalexamtype, self.curr_user.user_info.current_semester)
		
		if (user_type_badges.length >= self.count)
			return true
		end

	    return false
	end
end
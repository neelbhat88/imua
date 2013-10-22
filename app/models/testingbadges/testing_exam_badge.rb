class TestingExamBadge < TestingBadge
	attr_accessor :globalexamid, :count

	def initialize(globalbadge, user, semester)
		# call ActivityBadge contructor
		super

		self.globalexamid = globalbadge.comparevalue.split("|")[0].to_i # First part is Global Exam id
		self.count = globalbadge.comparevalue.split("|")[1].to_i # Second part is count
	end

	def Compare()
		if (self.curr_user.user_testings.where(:global_exam_id=>self.globalexamid,
					:semester=> self.semester).length >= self.count)
			return true
		end

	    return false
	end
end
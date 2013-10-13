class TestingPrepQuizBadge < TestingBadge
	attr_accessor :globalexamtype, :count, :score

	def initialize(globalbadge, user)
		# call ActivityBadge contructor
		super

		self.globalexamtype = globalbadge.comparevalue.split("|")[0] # First part is Global Exam Type
		self.count = globalbadge.comparevalue.split("|")[1].to_i # Second part is the count
		self.score = globalbadge.comparevalue.split("|")[2].to_f # Second part is the score
	end

	def Compare()
		user_prepquiz_badges = self.curr_user.user_testings.joins(:global_exam).where("global_exams.exam_type=? and user_testings.semester= ?", self.globalexamtype, self.curr_user.user_info.current_semester)
		
		# Have to earn at least the score on all the count (Earn at least 8/10 on all 8 prep quizzes)
		if (user_prepquiz_badges.length >= self.count)
			user_prepquiz_badges.each do |b|
				if b.score < self.score 
					return false
				end
			end

			return true
		end

	    return false
	end
end
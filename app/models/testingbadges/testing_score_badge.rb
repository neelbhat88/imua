class TestingScoreBadge < TestingBadge
	attr_accessor :globalexamid, :score

	def initialize(globalbadge, user, semester)
		# call ActivityBadge contructor
		super

		self.globalexamid = globalbadge.comparevalue.split("|")[0].to_i # First part is Global Exam id
		self.score = globalbadge.comparevalue.split("|")[1].to_i # Second part is score
	end

	def Compare()
		user_score_badges = self.curr_user.user_testings.where(:global_exam_id=>self.globalexamid,
											:semester=> self.semester)
		
		if (user_score_badges.length > 0)
			user_score_badges.each do | b |
				if (b.score >= self.score)
					return true
				end
			end
		end

	    return false
	end
end
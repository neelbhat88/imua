class TestingPrepQuizBadge < TestingBadge
	attr_accessor :completionPercent, :count, :score, :subcategory

	def initialize(globalbadge, user, semester)
		# call parent contructor
		super

		self.subcategory = globalbadge.subcategory
		self.completionPercent = globalbadge.comparevalue.to_f
	end

	def Compare()
		percentCompleteInfo = PracticeTestRepository.new().GetPercentCompletedInfo(self.curr_user.id)    	
		
		# Have to earn at least the score on all the count (Earn at least 8/10 on all 8 prep quizzes)
		if (percentCompleteInfo[:percentComplete_f] >= self.completionPercent)
			return true
		end

	    return false
	end

	def HasEarned()
		# Don't care about semester since a user can earn the next semesters badge during the current semester	
		self.user_badge = UserBadgeRepository.new().GetUserBadge(self.curr_user.id, self.id)

		if (self.user_badge.length > 1)
			Rails.logger.warn("***Warning*** More than 1 testing prep badge id #{self.id} for user #{self.curr_user.id}")
		end

		return self.user_badge.length != 0
	end
end
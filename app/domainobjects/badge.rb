class Badge
	attr_accessor :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :id, :curr_user, :value, :badge_semester,
                   :user_badge

	def initialize(globalbadge, user, semester)
		self.curr_user = user
		self.semester = semester
		self.id = globalbadge.id
		self.title = globalbadge.title
		self.isminrequirement = globalbadge.isminrequirement
		self.comparevalue = globalbadge.comparevalue
		self.description = globalbadge.description		
		self.value = globalbadge.badge_value
		self.badge_semester = globalbadge.semester # This may be null for badges that should be in every semester
	end

	def Compare()
		return false
	end

	def HasEarned()
		self.user_badge = UserBadgeRepository.new().GetUserBadge(self.curr_user.id, self.id, self.semester)

		if (self.user_badge.length > 1)
			Rails.logger.warn("***Warning*** More than 1 badge id #{self.id} for user #{self.curr_user.id}")
		end

		return self.user_badge.length != 0
	end
end
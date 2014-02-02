class PduBadge < Badge
	attr_accessor :category

	def initialize(globalbadge, user, semester)
		# Call parent constructor
		super

		self.category = globalbadge.category
	end

	def Compare()
		userpdus = self.curr_user.user_pdus.where("semester = ?", self.semester)

		return (userpdus.length >= self.comparevalue.to_i)
	end
end
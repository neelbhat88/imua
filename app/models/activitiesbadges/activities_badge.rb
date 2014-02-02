class ActivitiesBadge < Badge
	attr_accessor :category

	def initialize(globalbadge, user, semester)
		# Call parent constructor
		super

		self.category = globalbadge.category
	end
end
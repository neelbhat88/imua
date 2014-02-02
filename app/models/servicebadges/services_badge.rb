class ServicesBadge < Badge
	attr_accessor :category

	def initialize(globalbadge, user, semester)
		# Call parent constructor
		super

		self.category = globalbadge.category
	end

	def Compare()
		userservices = self.curr_user.user_services.where("semester = ?",	self.semester)

		totalHours = 0
		userservices.each do | s |
			totalHours += s.hours
		end

		return (totalHours >= self.comparevalue.to_i)
	end
end
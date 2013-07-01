class ActivityBadge
	attr_accessor :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :id, :curr_user

	def initialize(globalbadge, user)
		self.curr_user = user
		self.id = globalbadge.id
		self.title = globalbadge.title
		self.isminrequirement = globalbadge.isminrequirement
		self.comparevalue = globalbadge.comparevalue
		self.description = globalbadge.description
		self.semester = globalbadge.semester	
	end

	def Compare()
		return false
	end
end
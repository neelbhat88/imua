class ActivitiesBadge
	attr_accessor :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :id, :curr_user

	def initialize(globalbadge, user, semester)
		self.curr_user = user
		self.semester = semester
		self.id = globalbadge.id
		self.title = globalbadge.title
		self.isminrequirement = globalbadge.isminrequirement
		self.comparevalue = globalbadge.comparevalue
		self.description = globalbadge.description		
	end

	def Compare()
		return false
	end
end
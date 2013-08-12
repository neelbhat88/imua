class PduBadge
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
		userpdus = self.curr_user.user_pdus.where("semester = ?", self.curr_user.user_info.current_semester)	

		return (userpdus.length >= self.comparevalue.to_i)
	end
end
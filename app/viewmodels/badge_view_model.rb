class BadgeViewModel
	attr_accessor :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :hasEarned, :badgeValue

	def initialize(badge)		
		@category = badge.category
		@description = badge.description
		@isminrequirement = badge.isminrequirement
		@semester = badge.semester
		@title = badge.title
		@badgeValue = badge.value
		@subcategory = badge.subcategory

		@hasEarned = badge.HasEarned()
	end	
end
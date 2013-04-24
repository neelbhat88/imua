class BadgeViewModel
	attr_accessor :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :hasEarned

	def initialize(badge, hasEarned)		
		@category = badge.category		
		@description = badge.description
		@isminrequirement = badge.isminrequirement
		@semester = badge.semester
		@title = badge.title
		@hasEarned = hasEarned
	end	
end
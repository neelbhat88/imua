class GridBadgeViewModel
	attr_accessor :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :gridcellnum

	def initialize(userbadge)
		@category = userbadge.global_badge.category		
		@description = userbadge.global_badge.description
		@isminrequirement = userbadge.global_badge.isminrequirement
		@semester = userbadge.global_badge.semester
		@title = userbadge.global_badge.title
		@gridcellnum = userbadge.gridcellnum
	end
end
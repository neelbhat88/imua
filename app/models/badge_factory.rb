class BadgeFactory
	attr_accessor :curr_user

	def initialize(user)
		@curr_user = user
	end

	def GetAcademicsBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where("category = 'Academics'")
		else
			allBadges = GlobalBadge.where("category = 'Academics' and semester = ?", semester)
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			# GPA
			when 1
				badgeList << AcademicsGpaBadge.new(b, curr_user)
			# Letter Grade
			#when 2
			#	badgeList << AcademicsLetter
			else
				badgeList << AcademicsBadge.new(b, curr_user)
			end
		end

		return badgeList
	end
end
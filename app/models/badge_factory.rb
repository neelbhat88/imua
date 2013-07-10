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
			when 2
				badgeList << AcademicsGradeBadge.new(b, curr_user)
			# AP Score
			#when 3
				#badgeList << AcademicsAPScoreBadge.new(b, curr_user)
			# Class Credit
			#when 4
			#	badgeList << AcademicsClassCreditBadge.new(b, curr_user)
			else
				badgeList << AcademicsBadge.new(b, curr_user)
			end
		end

		return badgeList
	end

	def GetActivitiesBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where("category = 'Activity'")
		else
			allBadges = GlobalBadge.where("category = 'Activity' and semester = ?", semester)
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			# Involved in any Activity
			when 1
				badgeList << ActivitiesInvolvementBadge.new(b, curr_user)
			# Leadership role in any Activity
			when 2
				badgeList << ActivitiesLeadershipBadge.new(b, curr_user)
			# Specific Activity involvement?
			#when 3
				#badgeList << ActivitiesSpecificBadge.new(b, curr_user)			
			else
				badgeList << ActivitiesBadge.new(b, curr_user)
			end
		end

		return badgeList
	end
end
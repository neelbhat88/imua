class BadgeFactory
	attr_accessor :curr_user

	def initialize(user)
		@curr_user = user
	end

	def GetAcademicsBadges(semester=nil)
		if semester.nil?
			# ToDo: After changing GlobalBadge to allow null for semester, need to figure out
			#  how this will work. Not worried about this right now though
			allBadges = GlobalBadge.where(:category => "Academics")
		else
			allBadges = GlobalBadge.where(:category => "Academics", :semester => [nil, semester])
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			# GPA
			when 0
				badgeList << AcademicsGpaBadge.new(b, curr_user, semester)
			# Letter Grade
			when 1
				badgeList << AcademicsGradeBadge.new(b, curr_user, semester)
			# AP Score
			#when 2
				#badgeList << AcademicsAPScoreBadge.new(b, curr_user)
			# Class Credit
			#when 3
			#	badgeList << AcademicsClassCreditBadge.new(b, curr_user)
			else
				badgeList << AcademicsBadge.new(b, curr_user, semester)
			end
		end

		return badgeList
	end

	def GetActivitiesBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where(:category => "Activity")
		else
			allBadges = GlobalBadge.where(:category => "Activity", :semester => [nil, semester])
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			# Involved in any Activity
			when 0
				badgeList << ActivitiesInvolvementBadge.new(b, curr_user, semester)
			# Leadership role in any Activity
			when 1
				badgeList << ActivitiesLeadershipBadge.new(b, curr_user, semester)
			# Specific Activity involvement?
			#when 3
				#badgeList << ActivitiesSpecificBadge.new(b, curr_user)			
			else
				badgeList << ActivitiesBadge.new(b, curr_user, semester)
			end
		end

		return badgeList
	end

	def GetServicesBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where("category = 'Service'")
		else
			allBadges = GlobalBadge.where(:category => "Service", :semester => [nil, semester])
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			
			when 0
				badgeList << ServicesBadge.new(b, curr_user, semester)
			when 1			
			end
		end

		return badgeList
	end

	def GetPduBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where("category = 'PDU'")
		else
			allBadges = GlobalBadge.where(:category => "PDU", :semester => [nil, semester])
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			
			when 0
				badgeList << PduBadge.new(b, curr_user, semester)
			when 1			
			end
		end

		return badgeList
	end

	def GetTestingBadges(semester=nil)
		if semester.nil?
			allBadges = GlobalBadge.where(:category => "Testing")
		else
			allBadges = GlobalBadge.where(:category => "Testing", :semester => [nil, semester])
		end

		badgeList = []

		allBadges.each do |b|
			case b.subcategory
			
			when 0
				badgeList << TestingExamBadge.new(b, curr_user, semester)
			when 1
				badgeList << TestingScoreBadge.new(b, curr_user, semester)
			when 2
				badgeList << TestingExamTypeBadge.new(b, curr_user, semester)
			when 3
				badgeList << TestingPrepQuizBadge.new(b, curr_user, semester)
			end
		end

		return badgeList
	end
end
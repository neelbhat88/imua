class BadgeFactory
	attr_accessor :curr_user

	def initialize(user)
		@curr_user = user
	end

	def GetBadges(semester, category=nil)
		db_badges = GlobalBadgeRepository.new().LoadAllBadges(semester, category)

		badgeList = []
		db_badges.each do |b|
			case b.category.downcase
			when "academics"
				badgeList << GetAcademicsBadge(b, semester)
			when "activity"
				badgeList << GetActivityBadge(b, semester)
			when "service"
				badgeList << GetServicesBadge(b, semester)
			when "pdu"
				badgeList << GetPduBadge(b, semester)			
			when "testing"
				badgeList << GetTestingBadge(b, semester)
			else
				Rails.logger.warn "BadgeFactory: Badge id:#{b.id} has invalid category #{b.category}"
			end
		end

		return badgeList
	end	

	def GetTestingPracticeTestBadges()
		allBadges = GlobalBadgeRepository.new().LoadAllBadgesBySubCategory("Testing", 3)

		badgeList = []

		allBadges.each do |b|
			badgeList << GetTestingBadge(b, nil)
		end

		return badgeList
	end

	private
	def GetAcademicsBadge(badge, semester)
		case badge.subcategory
		# GPA
		when 0
			return AcademicsGpaBadge.new(badge, curr_user, semester)
		# Letter Grade
		when 1
			return AcademicsGradeBadge.new(badge, curr_user, semester)
		# AP Score
		#when 2
			#badgeList << AcademicsAPScoreBadge.new(b, curr_user)
		# Class Credit
		#when 3
		#	badgeList << AcademicsClassCreditBadge.new(b, curr_user)
		else
			return  AcademicsBadge.new(badge, curr_user, semester)
		end
	end

	def GetActivityBadge(badge, semester)
		case badge.subcategory
		# Involved in any Activity
		when 0
			return ActivitiesInvolvementBadge.new(badge, curr_user, semester)
		# Leadership role in any Activity
		when 1
			return ActivitiesLeadershipBadge.new(badge, curr_user, semester)
		# Specific Activity involvement?
		#when 3
			#badgeList << ActivitiesSpecificBadge.new(b, curr_user)			
		else
			return ActivitiesBadge.new(badge, curr_user, semester)
		end
	end

	def GetServicesBadge(badge, semester)
		case badge.subcategory			
		when 0
			return ServicesBadge.new(badge, curr_user, semester)
		end
	end

	def GetPduBadge(badge, semester)
		case badge.subcategory			
		when 0
			return PduBadge.new(badge, curr_user, semester)
		end
	end

	def GetTestingBadge(badge, semester)
		case badge.subcategory		
		when 0
			return TestingExamBadge.new(badge, curr_user, semester)
		when 1
			return TestingScoreBadge.new(badge, curr_user, semester)
		when 2
			return TestingExamTypeBadge.new(badge, curr_user, semester)
		when 3
			return TestingPrepQuizBadge.new(badge, curr_user, semester)
		end
	end	
end
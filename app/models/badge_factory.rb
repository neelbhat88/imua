class BadgeFactory
	attr_accessor :user, :semester, :category
				:globalBadgeRepo

	def initialize(globalBadgeRepo=GlobalBadgeRepository.new)
		@globalBadgeRepo = globalBadgeRepo
	end

	def GetBadges(opts={})
		@user = opts[:user]
		@semester = opts[:semester]
		@category = opts[:category]

		db_badges = @globalBadgeRepo.LoadAllBadges(@semester, @category)

		badgeList = []
		db_badges.each do |b|
			case b.category.downcase
			when "academics"
				badgeList << GetAcademicsBadge(b)
			when "activity"
				badgeList << GetActivityBadge(b)
			when "service"
				badgeList << GetServicesBadge(b)
			when "pdu"
				badgeList << GetPduBadge(b)
			when "testing"
				badgeList << GetTestingBadge(b)
			else
				Rails.logger.warn "BadgeFactory: Badge id:#{b.id} has invalid category #{b.category}"
			end
		end

		return badgeList
	end	

	def GetTestingPracticeTestBadges(opts={})
		@user = opts[:user]
		@semester = opts[:semester]
		
		allBadges = @globalBadgeRepo.LoadAllBadgesBySubCategory("Testing", 3)

		badgeList = []

		allBadges.each do |b|
			badgeList << GetTestingBadge(b)
		end

		return badgeList
	end

	private
	def GetAcademicsBadge(badge)
		case badge.subcategory
		# GPA
		when 0
			return AcademicsGpaBadge.new(badge, @user, @semester)
		# Letter Grade
		when 1
			return AcademicsGradeBadge.new(badge, @user, @semester)
		# AP Score
		#when 2
			#badgeList << AcademicsAPScoreBadge.new(b, @user, @semester)
		# Class Credit
		#when 3
		#	badgeList << AcademicsClassCreditBadge.new(b, @user, @semester)
		else
			return  AcademicsBadge.new(badge, @user, @semester)
		end
	end

	def GetActivityBadge(badge)
		case badge.subcategory
		# Involved in any Activity
		when 0
			return ActivitiesInvolvementBadge.new(badge, @user, @semester)
		# Leadership role in any Activity
		when 1
			return ActivitiesLeadershipBadge.new(badge, @user, @semester)
		# Specific Activity involvement?
		#when 3
			#badgeList << ActivitiesSpecificBadge.new(b, @user, @semester)
		else
			return ActivitiesBadge.new(badge, @user, @semester)
		end
	end

	def GetServicesBadge(badge)
		case badge.subcategory			
		when 0
			return ServicesBadge.new(badge, @user, @semester)
		end
	end

	def GetPduBadge(badge)
		case badge.subcategory			
		when 0
			return PduBadge.new(badge, @user, @semester)
		end
	end

	def GetTestingBadge(badge)
		case badge.subcategory		
		when 0
			return TestingExamBadge.new(badge, @user, @semester)
		when 1
			return TestingScoreBadge.new(badge, @user, @semester)
		when 2
			return TestingExamTypeBadge.new(badge, @user, @semester)
		when 3
			return TestingPrepQuizBadge.new(badge, @user, @semester)
		end
	end	
end
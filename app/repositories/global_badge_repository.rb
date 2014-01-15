class GlobalBadgeRepository
	def initialize()
	end

	def LoadAllBadges(semester, category=nil)
		if (category == nil)
			return GlobalBadge.where(:semester => [nil, semester])
		else
			return GlobalBadge.where(:semester => [nil, semester], :category => category)
		end
	end

	def LoadAllMinReqBadges(semester)
		return GlobalBadge.where(:semester => [nil, semester], :isminrequirement => true)
	end
end
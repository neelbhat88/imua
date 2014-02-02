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

	def LoadAllBadgesByCategory(category)
		return GlobalBadge.where(:category => category)
	end

	def LoadAllBadgesBySubCategory(category, subcategory)
		return GlobalBadge.where(:category => category, :subcategory=> subcategory)
	end

	def LoadAllMinReqBadges(semester)
		return GlobalBadge.where(:semester => [nil, semester], :isminrequirement => true)
	end

	def GetNumBadgesEarned(current_user, semester=nil)
	    if (semester == nil)
	      return current_user.user_badges.length
	    end

	    return current_user.user_badges.where(:semester => semester).length
  	end
end
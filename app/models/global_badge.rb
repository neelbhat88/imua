class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title

  def GetCategories
  	return ['Academics', 'Activity', 'Service', 'PDU']
  end

  def GetSubCategories(category)
  	subcategories = {
  		'Academics' => ['GPA', 'LetterGrade', 'APScore', 'ClassCredit'],
      'Activity' => ['Involvement', 'Leadership'],
      'Service' => ['Service'],
      'PDU' => ['PDU']
  	}  	

  	return subcategories[category]
  end

  # Static method
  def self.GetBadgesViewModel(allbadges, user)
    badgesviewmodel = []
    allbadges.each do | badge |
      hasEarned = "No"

      # If User has earned badge
      if user.user_badges.find_by_global_badge_id(badge.id) != nil
        if !badge.isminrequirement() && !user.user_info.MetAllMinRequirements()
          hasEarned = "Pending"
        else
          hasEarned = "Yes"
        end
      end      

      badgesviewmodel << BadgeViewModel.new(badge, hasEarned)
    end

    return badgesviewmodel
  end
end

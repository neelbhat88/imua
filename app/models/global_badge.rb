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
    allbadges.each do | ab |
      hasEarned = false
      
      if user.user_badges.find_by_global_badge_id(ab.id) != nil
        hasEarned = true
      end

      badgesviewmodel << BadgeViewModel.new(ab, hasEarned)
    end

    return badgesviewmodel
  end
end

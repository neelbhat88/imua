class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title

  default_scope order('id ASC')

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
  def self.GetBadgesViewModel(allbadges, user, semester=nil)
    if (semester == nil)
      semester = user.user_info.current_semester
    end

    badgesviewmodel = []
    allbadges.each do | badge |
      hasEarned = "No"

      logger.debug("DEBUG: GetBadgesViewModel - #{user.user_badges.where(:semester => semester, :global_badge_id => badge.id).length}")
      # If User has earned badge
      if user.user_badges.where(:semester => semester, :global_badge_id => badge.id).length != 0
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

class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title, :badge_value

  default_scope order('id ASC')

  def GetCategories
  	return ['Academics', 'Activity', 'Service', 'PDU', 'Testing']
  end

  def GetSubCategories(category)
  	subcategories = {
  		'Academics' => ['GPA', 'LetterGrade', 'APScore', 'ClassCredit'],
      'Activity' => ['Involvement', 'Leadership'],
      'Service' => ['Service'],
      'PDU' => ['PDU'],
      'Testing' => ['Exam', 'Score', 'ExamType']
  	}  	

  	return subcategories[category]
  end

  # Static method
  def self.GetBadgesViewModel(allbadges, user, semester=nil)
    if (semester == nil)
      semester = user.user_info.current_semester
    end

    badgesviewmodel = []
    user_badges = user.user_badges #loads all badges from DB

    allbadges.each do | badge |
      hasEarned = "No"
          
      # If User has earned badge
      if user_badges.select{|ub| ub.semester == semester && ub.global_badge_id == badge.id}.length != 0                
          hasEarned = "Yes"
      end

      badgesviewmodel << BadgeViewModel.new(badge, hasEarned)
    end

    return badgesviewmodel
  end

  def self.GetNumBadgesEarned(current_user, semester=nil)
    if (semester == nil)
      return current_user.user_badges.length
    end

    return current_user.user_badges.where(:semester => semester).length
  end
end

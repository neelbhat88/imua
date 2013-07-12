class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title

  def GetCategories
  	return ['Academics', 'Activity', 'Service']
  end

  def GetSubCategories(category)
  	subcategories = {
  		'Academics' => ['RunningGPA', 'GPA', 'LetterGrade', 'APScore', 'ClassCredit'],
      'Activity' => ['Involvement', 'Leadership'],
      'Service' => ['Service'],
  	}  	

  	return subcategories[category]
  end
end

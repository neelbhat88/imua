class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title

  def GetCategories
  	return ['Academics', 'Activity']
  end

  def GetSubCategories(category)
  	subcategories = {
  		'Academics' => ['RunningGPA', 'GPA', 'LetterGrade', 'APScore', 'ClassCredit'],
      'Activity' => ['Involvement', 'Leadership']
  	}  	

  	return subcategories[category]
  end
end

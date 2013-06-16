class GlobalBadge < ActiveRecord::Base
  attr_accessible :category, :comparevalue, :description, :isminrequirement, :semester,
                   :subcategory, :title

  def GetCategories
  	return ['Academics']
  end

  def GetSubCategories(category)
  	subcategories = {
  		'Academics' => ['RunningGPA', 'GPA', 'LetterGrade', 'APScore', 'ClassCredit']
  	}  	

  	return subcategories[category]
  end
end

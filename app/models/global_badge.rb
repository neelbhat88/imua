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
end

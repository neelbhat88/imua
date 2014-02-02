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
      'Testing' => ['TakeExam', 'ScoreAbove', 'ExamType-official', 'PrepQuizzes']
  	}  	

  	return subcategories[category]
  end
end

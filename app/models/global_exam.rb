class GlobalExam < ActiveRecord::Base
  attr_accessible :name, :exam_type  

  def self.GetTypes()
  	return [
  			['Practice ACT/SAT', 'PracticeACTSAT'],
  			['ACT/SAT', 'ACTSAT'],
  			['Regular', 'Regular'],
  			['Subject', 'Subject'], 
  			['WCSF Prep Quiz', 'WCSFPrepQuiz']
  		]
  end
end

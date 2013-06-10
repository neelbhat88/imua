class UserInfo < ActiveRecord::Base
  attr_accessible :current_semester, :school_id, :user_id

  belongs_to :user
  belongs_to :school

  def GetTotalGpa
    semester_classes = self.user.user_classes.where('semester = ?', self.current_semester)
  	numclasses = semester_classes.length    
  	classeswithgrade = 0
  	totalGpa = 0.0    

  	semester_classes.each do |c|
  		unless c.grade.nil?        
        totalGpa += c.gpa
        classeswithgrade += 1
      end
  	end

    # Must have at least 5 classes with grade to earn GPA badges
    if (classeswithgrade < 5)
      return 0
    end

    return (totalGpa / classeswithgrade).round(2)
  end
end

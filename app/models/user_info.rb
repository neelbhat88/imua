class UserInfo < ActiveRecord::Base
  attr_accessible :current_semester, :school_id, :user_id

  belongs_to :user
  belongs_to :school

  def GetTotalGpa
    # NEED TO TAKE INTO ACCOUNT SEMESTERS HERE!
  	numclasses = self.user.user_classes.length
  	classeswithgrade = 0
  	totalGpa = 0.0

  	self.user.user_classes.each do |c|
  		unless c.grade.nil?        
        totalGpa += c.gpa
        classeswithgrade += 1
      end
  	end

    return (totalGpa / classeswithgrade).round(2)
  end
end

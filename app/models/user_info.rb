class UserInfo < ActiveRecord::Base
  attr_accessible :current_semester, :school_id, :user_id, :big_goal, :why_description, :how_description, :college_avatar, :avatar

  belongs_to :user
  belongs_to :school

  has_attached_file :avatar
  has_attached_file :college_avatar

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

  def MetAllMinRequirements(semester=nil)
    if (semester == nil)
      semester = self.current_semester
    end

    minreq_badges = GlobalBadge.where(:semester => [nil, semester], :isminrequirement => true)

    minreq_badges.each do |b|
      if self.user.user_badges.where(:global_badge_id => b.id, :semester => semester).length == 0
        return false
      end
    end

    return true
  end
end

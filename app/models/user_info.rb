class UserInfo < ActiveRecord::Base
  attr_accessible :current_semester, :school_id, :user_id, :classof, :phone,
                  :big_goal, :why_description, :how_description, :college_avatar, :avatar

  belongs_to :user
  belongs_to :school

  has_attached_file :avatar
  has_attached_file :college_avatar

  def MetAllMinRequirements(semester=nil)
    if (semester == nil)
      semester = self.current_semester
    end

    minreq_badges = GlobalBadge.where(:semester => [nil, semester], :isminrequirement => true)

    # ToDo: Remove this if the block below this works
    # minreq_badges.each do |b|
    #   if self.user.user_badges.where(:global_badge_id => b.id, :semester => semester).length == 0
    #     return false
    #   end
    # end

    user_badges = self.user.user_badges.where(:semester => semester)
    minreq_badges.each do |b|
      if user_badges.select{|badge| badge.global_badge_id == b.id}.length == 0
        return false
      end
    end

    return true
  end

  def self.GetClassYears
    return [2016, 2017]
  end
end

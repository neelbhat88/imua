class UserActivity < ActiveRecord::Base
  attr_accessible :description, :leadership_held, :leadership_title, :school_activity_id, :semester, :user_id

  belongs_to :user
  belongs_to :school_activity
end

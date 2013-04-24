class UserClass < ActiveRecord::Base
  attr_accessible :gpa, :grade, :level, :name, :semester, :user_id

  belongs_to :user
end

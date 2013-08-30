class UserSemesterGpa < ActiveRecord::Base
  attr_accessible :gpa, :semester, :user_id

  belongs_to :user 
end

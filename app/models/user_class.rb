class UserClass < ActiveRecord::Base
  attr_accessible :gpa, :grade, :level, :name, :semester, :user_id, :school_class_id

  belongs_to :user
  belongs_to :school_class
end
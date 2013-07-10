class UserService < ActiveRecord::Base
  attr_accessible :date, :hours, :name, :semester, :user_id

  belongs_to :user 
end

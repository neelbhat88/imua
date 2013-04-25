class UserInfo < ActiveRecord::Base
  attr_accessible :current_semester, :school_id

  belongs_to :user
end

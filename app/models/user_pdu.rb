class UserPdu < ActiveRecord::Base
  attr_accessible :date, :hours, :school_pdu_id, :semester, :user_id

  belongs_to :user 
  belongs_to :school_pdu
end

class UserDeduction < ActiveRecord::Base
  attr_accessible :deduction_details, :deduction_level, :semester, :deduction_type, 
  					:user_id, :deduction_value

  # Type - 'Documents' 'Meetings' 'Communications'
end

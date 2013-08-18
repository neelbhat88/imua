class UserTesting < ActiveRecord::Base
  attr_accessible :date, :global_exam_id, :score, :semester, :user_id

  belongs_to :user
  belongs_to :global_exam
end

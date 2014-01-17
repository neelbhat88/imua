class UserPracticeTest < ActiveRecord::Base
  attr_accessible :global_practice_test_id, :score, :user_id

  belongs_to :user
  belongs_to :global_practice_test
end

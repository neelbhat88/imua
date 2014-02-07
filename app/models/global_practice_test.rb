class GlobalPracticeTest < ActiveRecord::Base
  attr_accessible :name, :section, :semester, :subject

  has_many :global_practice_test_questions, dependent: :destroy
  has_many :user_practice_tests, dependent: :destroy
end

class GlobalPracticeTest < ActiveRecord::Base
  attr_accessible :name, :section, :semester, :subject

  has_many :user_practice_tests
end

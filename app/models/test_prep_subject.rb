class TestPrepSubject < ActiveRecord::Base
  attr_accessible :name

  has_many :test_prep_categories
end

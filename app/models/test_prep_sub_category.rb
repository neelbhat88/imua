class TestPrepSubCategory < ActiveRecord::Base
  attr_accessible :description, :level, :name, :test_prep_category_id

  belongs_to :test_prep_category

  has_many :test_prep_questions
end

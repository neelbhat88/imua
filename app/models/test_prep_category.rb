class TestPrepCategory < ActiveRecord::Base
  attr_accessible :level, :name, :test_prep_subject_id

  belongs_to :test_prep_subject

  has_many :test_prep_sub_categories
end

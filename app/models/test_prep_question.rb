class TestPrepQuestion < ActiveRecord::Base
  attr_accessible :question_text, :solution_url, :test_prep_sub_category_id

  belongs_to :test_prep_sub_category
end

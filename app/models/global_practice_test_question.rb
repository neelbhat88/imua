class GlobalPracticeTestQuestion < ActiveRecord::Base
	attr_accessible :global_practice_test_id, :id, :number, 
					:question_text, :solution_url

	has_attached_file :picture

	belongs_to :global_practice_test
	has_many :global_practice_test_answers, dependent: :destroy
end
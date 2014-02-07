class GlobalPracticeTestAnswer < ActiveRecord::Base
 	attr_accessible :answer_text, :global_practice_test_question_id, 
  					:id, :is_correct, :position

	belongs_to :global_practice_test_question
end

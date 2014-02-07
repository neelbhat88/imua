class CreateGlobalPracticeTestAnswers < ActiveRecord::Migration
  def change
    create_table :global_practice_test_answers do |t|
      t.integer :id
      t.integer :global_practice_test_question_id
      t.string :answer_text
      t.bool :is_correct
      t.integer :position

      t.timestamps
    end
  end
end

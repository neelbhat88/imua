class CreateGlobalPracticeTestQuestions < ActiveRecord::Migration
  def change
    create_table :global_practice_test_questions do |t|
      t.integer :id
      t.integer :global_practice_test_id
      t.integer :number
      t.text :question_text
      t.string :solution_url

      t.timestamps    
    end
    
    add_attachment :global_practice_test_questions, :picture
  end
end

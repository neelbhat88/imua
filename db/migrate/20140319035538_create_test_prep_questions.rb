class CreateTestPrepQuestions < ActiveRecord::Migration
  def change
    create_table :test_prep_questions do |t|
      t.integer :test_prep_sub_category_id
      t.string :question_text
      t.string :solution_url

      t.timestamps
    end

    add_index 'test_prep_questions', ["test_prep_sub_category_id"], :name => "IDX_TestPrepQuestion_TestPrepSubCategory"
  end  
end

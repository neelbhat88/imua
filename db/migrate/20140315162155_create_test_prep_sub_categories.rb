class CreateTestPrepSubCategories < ActiveRecord::Migration
  def change
    create_table :test_prep_sub_categories do |t|
      t.integer :test_prep_category_id
      t.string :name
      t.text :description
      t.integer :level

      t.timestamps
    end

    add_index 'test_prep_sub_categories', ["test_prep_category_id"], :name => "IDX_TestPrepSubCategory_TestPrepCategory"
    add_index 'test_prep_categories', ["test_prep_subject_id"], :name => "IDX_TestPrepCategory_TestPrepSubject"
  end
end

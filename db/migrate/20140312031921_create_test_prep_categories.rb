class CreateTestPrepCategories < ActiveRecord::Migration
  def change
    create_table :test_prep_categories do |t|
      t.integer :test_prep_subject_id
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end

class CreateTestPrepSubjects < ActiveRecord::Migration
  def change
    create_table :test_prep_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end

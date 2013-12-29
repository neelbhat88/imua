class CreateGlobalPracticeTests < ActiveRecord::Migration
  def change
    create_table :global_practice_tests do |t|
      t.string :name
      t.integer :semester
      t.string :section
      t.string :subject

      t.timestamps
    end
  end
end

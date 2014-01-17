class CreateUserPracticeTests < ActiveRecord::Migration
  def change
    create_table :user_practice_tests do |t|
      t.integer :global_practice_test_id
      t.decimal :score
      t.integer :user_id

      t.timestamps
    end
  end
end

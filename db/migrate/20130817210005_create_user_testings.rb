class CreateUserTestings < ActiveRecord::Migration
  def change
    create_table :user_testings do |t|
      t.integer :global_exam_id
      t.integer :user_id
      t.integer :semester
      t.date :date
      t.integer :hours

      t.timestamps
    end
  end
end

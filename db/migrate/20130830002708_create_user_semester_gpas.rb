class CreateUserSemesterGpas < ActiveRecord::Migration
  def change
    create_table :user_semester_gpas do |t|
      t.integer :user_id
      t.integer :semester
      t.float :gpa

      t.timestamps
    end
  end
end

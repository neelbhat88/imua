class CreateUserClasses < ActiveRecord::Migration
  def change
    create_table :user_classes do |t|
      t.integer :userid
      t.string :name
      t.integer :level
      t.string :grade
      t.float :gpa
      t.integer :semester

      t.timestamps
    end
  end
end

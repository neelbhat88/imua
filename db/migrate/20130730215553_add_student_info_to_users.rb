class AddStudentInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :big_goal, :text
    add_column :users, :how_description, :text
    add_column :users, :why_description, :text
  end
end

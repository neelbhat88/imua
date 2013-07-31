class RemoveStudentInfoFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :big_goal
    remove_column :users, :why_description
    remove_column :users, :how_description
  end
end

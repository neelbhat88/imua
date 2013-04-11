class AddRoleAndCurrentsemToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, :default => 0 # student
    add_column :users, :current_semester, :integer, :default => 1
  end
end

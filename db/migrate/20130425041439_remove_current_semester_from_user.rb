class RemoveCurrentSemesterFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :current_semester

  	add_column :users, :user_info_id, :integer
  end
end

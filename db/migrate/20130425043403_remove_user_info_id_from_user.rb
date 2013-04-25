class RemoveUserInfoIdFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :user_info_id
  	
  	add_column :user_infos, :user_id, :integer
  end
end

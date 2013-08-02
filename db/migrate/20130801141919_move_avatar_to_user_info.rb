class MoveAvatarToUserInfo < ActiveRecord::Migration
  def change
    remove_attachment :users, :avatar
    add_attachment :user_infos, :avatar
    remove_column :user_infos, :college
  end
end

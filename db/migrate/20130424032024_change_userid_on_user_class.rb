class ChangeUseridOnUserClass < ActiveRecord::Migration
  def change
  	rename_column :user_classes, :userid, :user_id
  end
end

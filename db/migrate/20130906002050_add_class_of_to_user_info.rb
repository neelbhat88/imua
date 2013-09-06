class AddClassOfToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :classof, :integer, :default => 2016
  end
end

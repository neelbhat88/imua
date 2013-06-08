class AddRownumToUserBadge < ActiveRecord::Migration
  def change
    add_column :user_badges, :rownum, :integer
  end
end

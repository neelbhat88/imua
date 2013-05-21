class AddGridcellnumToUserBadges < ActiveRecord::Migration
  def change
    add_column :user_badges, :gridcellnum, :integer
  end
end

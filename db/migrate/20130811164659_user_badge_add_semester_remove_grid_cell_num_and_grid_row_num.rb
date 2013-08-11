class UserBadgeAddSemesterRemoveGridCellNumAndGridRowNum < ActiveRecord::Migration
  def change
  	remove_column :user_badges, :gridcellnum
  	remove_column :user_badges, :rownum

  	add_column :user_badges, :semester, :integer
  end
end

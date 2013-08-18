class UserTestingChangeHoursToScore < ActiveRecord::Migration
  def change
  	rename_column :user_testings, :hours, :score
  end
end

class UserServiceChangeHoursTypeToFloat < ActiveRecord::Migration
  def change
  	change_column :user_services, :hours, :float
  end
end

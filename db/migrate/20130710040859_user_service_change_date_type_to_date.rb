class UserServiceChangeDateTypeToDate < ActiveRecord::Migration
  def change
  	change_column :user_services, :date, :date
  end
end

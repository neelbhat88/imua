class ChangeUserRoleValues < ActiveRecord::Migration
  def change
  	User.connection.execute("update users set role = 50 where role = 0")
  	User.connection.execute("update users set role = 20 where role = 1")
  	User.connection.execute("update users set role = 0 where role = 2")
  end
end

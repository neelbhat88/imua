class ChangeHoursDatatypeFromUserPdus < ActiveRecord::Migration
  def up
    change_column :user_pdus, :hours, :decimal
    change_column :user_testings, :score, :decimal
  end

  def down
    change_column :user_pdus, :hours, :integer
    change_column :user_testings, :score, :integer
  end
end

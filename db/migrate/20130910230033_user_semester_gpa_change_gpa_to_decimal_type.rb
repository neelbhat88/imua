class UserSemesterGpaChangeGpaToDecimalType < ActiveRecord::Migration
  def change
  	change_column :user_semester_gpas, :gpa, :decimal
  end
end

class AddSemesterToUserPracticeTest < ActiveRecord::Migration
  def change
    add_column :user_practice_tests, :semester, :integer
  end
end

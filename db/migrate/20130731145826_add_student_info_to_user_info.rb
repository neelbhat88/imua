class AddStudentInfoToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :big_goal, :text
    add_column :user_infos, :why_description, :text
    add_column :user_infos, :how_description, :text
    add_column :user_infos, :college, :string
    add_attachment :user_infos, :college_avatar
  end
end

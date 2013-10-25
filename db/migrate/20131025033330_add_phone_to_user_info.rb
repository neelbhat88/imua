class AddPhoneToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :phone, :string
  end
end

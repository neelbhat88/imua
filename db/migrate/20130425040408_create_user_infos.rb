class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.integer :current_semester, {:default => 1}
      t.integer :school_id

      t.timestamps
    end
  end
end

class CreateUserBadges < ActiveRecord::Migration
  def change
    create_table :user_badges do |t|
      t.integer :user_id
      t.integer :global_badge_id

      t.timestamps
    end
  end
end

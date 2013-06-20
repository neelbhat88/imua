class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.integer :school_activity_id
      t.boolean :leadership_held
      t.string :leadership_title
      t.text :description
      t.integer :semester
      t.integer :user_id

      t.timestamps
    end
  end
end

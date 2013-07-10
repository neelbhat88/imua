class CreateUserServices < ActiveRecord::Migration
  def change
    create_table :user_services do |t|
      t.integer :user_id
      t.integer :semester
      t.string :name
      t.integer :hours
      t.datetime :date

      t.timestamps
    end
  end
end

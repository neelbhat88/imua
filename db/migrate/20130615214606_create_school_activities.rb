class CreateSchoolActivities < ActiveRecord::Migration
  def change
    create_table :school_activities do |t|
      t.integer :school_id
      t.string :name

      t.timestamps
    end
  end
end

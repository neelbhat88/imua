class CreateSchoolClasses < ActiveRecord::Migration
  def change
    create_table :school_classes do |t|
      t.integer :school_id
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end

class CreateSchoolPdus < ActiveRecord::Migration
  def change
    create_table :school_pdus do |t|
      t.string :name
      t.integer :school_id

      t.timestamps
    end
  end
end

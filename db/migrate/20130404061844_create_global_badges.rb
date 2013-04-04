class CreateGlobalBadges < ActiveRecord::Migration
  def change
    create_table :global_badges do |t|
      t.string :Title
      t.string :Category
      t.integer :Semester
      t.boolean :IsMinRequirement
      t.text :Description
      t.integer :SubCategory
      t.integer :CompareValue

      t.timestamps
    end
  end
end

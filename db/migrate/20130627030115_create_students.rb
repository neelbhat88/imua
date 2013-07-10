class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :big_goal
      t.text :why_description
      t.text :how_description
      t.string :image_url

      t.timestamps
    end
  end
end

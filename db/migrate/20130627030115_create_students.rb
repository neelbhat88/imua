class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :big_goal
      t.string :why_description
      t.string :how_description
      t.string :image_url

      t.timestamps
    end
  end
end

class CreateToDoItems < ActiveRecord::Migration
  def change
    create_table :to_do_items do |t|
      t.integer :user_id
      t.integer :assigned_by_id
      t.string :description
      t.datetime :date_due
      t.boolean :completed
      t.datetime :date_complete
      t.boolean :verified
      t.datetime :date_verified
      t.text :notes

      t.timestamps
    end

    add_index 'to_do_items', ["user_id"], :name => "IDX_ToDoItem_UserId"
  end
end

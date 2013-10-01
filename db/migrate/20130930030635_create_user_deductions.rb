class CreateUserDeductions < ActiveRecord::Migration
  def change
    create_table :user_deductions do |t|
      t.integer :user_id
      t.string :deduction_type
      t.integer :deduction_level
      t.integer :deduction_value
      t.string :deduction_details
      t.integer :semester

      t.timestamps
    end

    add_index :user_deductions, :user_id, :name => 'IDX_UserDeductions_UserId'
  end
end

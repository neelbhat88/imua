class SchoolClassAddCreditHours < ActiveRecord::Migration
  def change
  	add_column :school_classes, :credit_hours, :float, :default => 1.0
  end
end

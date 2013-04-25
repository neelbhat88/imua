class AddSchoolClassIdToUserClasses < ActiveRecord::Migration
  def change
    add_column :user_classes, :school_class_id, :integer, :default => 3
  end
end

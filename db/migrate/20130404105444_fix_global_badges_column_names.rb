class FixGlobalBadgesColumnNames < ActiveRecord::Migration
  def change
  	rename_column :global_badges, :Title, :title
  	rename_column :global_badges, :Category, :category
  	rename_column :global_badges, :Semester, :semester
  	rename_column :global_badges, :IsMinRequirement, :isminrequirement
  	rename_column :global_badges, :Description, :description
  	rename_column :global_badges, :SubCategory, :subcategory
  	rename_column :global_badges, :CompareValue, :comparevalue
  end
end

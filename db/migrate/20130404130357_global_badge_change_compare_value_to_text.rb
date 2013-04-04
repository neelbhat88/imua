class GlobalBadgeChangeCompareValueToText < ActiveRecord::Migration
  def change
  	change_column :global_badges, :comparevalue, :string
end

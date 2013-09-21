class AddScholarshipPointsToGlobalBadge < ActiveRecord::Migration
  def change
  	add_column :global_badges, :badge_value, :integer, :default => 0
  end
end

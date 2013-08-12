class UserBadge < ActiveRecord::Base
  attr_accessible :global_badge_id, :user_id, :semester

  belongs_to :user
  belongs_to :global_badge
end

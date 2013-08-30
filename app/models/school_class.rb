class SchoolClass < ActiveRecord::Base
  attr_accessible :level, :name, :school_id, :credit_hours

  belongs_to :school

  validates :name, presence: true
end

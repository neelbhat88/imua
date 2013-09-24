class SchoolActivity < ActiveRecord::Base
  attr_accessible :name, :school_id

  belongs_to :school  

  validates :name, presence: true
end

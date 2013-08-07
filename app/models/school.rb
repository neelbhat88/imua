class School < ActiveRecord::Base
  attr_accessible :name

  has_many :school_classes

end

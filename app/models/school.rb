class School < ActiveRecord::Base
  attr_accessible :name

  has_many :school_classes
  has_many :school_activities
  has_many :school_pdus

end

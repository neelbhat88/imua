class School < ActiveRecord::Base
  attr_accessible :name

  has_many :user_infos
  has_many :school_classes
end

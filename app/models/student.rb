class Student < ActiveRecord::Base
  attr_accessible :big_goal, :first_name, :how_description, :image_url, :last_name, :why_description

  validates_presence_of :first_name, :last_name
end

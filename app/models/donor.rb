class Donor < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  validates_presence_of :first_name, :last_name

  default_scope order: 'last_name ASC'
end

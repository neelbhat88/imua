class UserClass < ActiveRecord::Base
  attr_accessible :gpa, :grade, :level, :name, :semester, :user_id, :school_class_id

  before_save :set_gpa

  belongs_to :user
  belongs_to :school_class

  private
  	def set_gpa
  		gpaHash = Hash.new()
  		gpaHash = {
  			'A' =>  4.0,  'A-' => 3.67, 
  			'B+' => 3.33, 'B' =>  3.00, 'B-' => 2.67, 
  			'C+' => 2.33, 'C' =>  2.00, 'C-' => 1.67, 
  			'D' => 1.33, 
  			'F' => 1.0
  		}

  		self.gpa = gpaHash[self.grade]

  		return true
  	end
end
class GlobalExam < ActiveRecord::Base
  attr_accessible :name, :exam_type

  # Types are: Practice, Regular, Subject
end

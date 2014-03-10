class ToDoItem < ActiveRecord::Base
  attr_accessible :assigned_by_id, :completed, :date_complete, :date_due, :date_verified, :description, :notes, :user_id, :verified

  belongs_to :user
end

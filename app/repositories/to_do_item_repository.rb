class ToDoItemRepository
	def initialize
	end

	def GetItemsAssignedToUser(user)
		return user.to_do_items.where(:completed => false, :verified=>false).order("date_due")
	end
end
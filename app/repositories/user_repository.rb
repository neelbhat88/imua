class UserRepository
	def initialize()
	end

	def LoadUser(userId)
		return User.find(userId)
	end
end
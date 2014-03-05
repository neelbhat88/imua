class UserRepository
	def initialize()
	end

	def LoadUser(userId)
		return User.find(userId)
	end

	def LoadStudentsBySchoolId(school_id)
	    # Default order is Last name
	    return User.joins(:user_info).where("users.role = 50 and user_infos.school_id = ?", school_id).order("users.last_name ASC")
	end
end
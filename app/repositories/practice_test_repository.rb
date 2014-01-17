class PracticeTestRepository
	def initialize()		
	end

	# Returns 2-d Array of PracticeTest objects
	def LoadTestsAsArray(userId, section=nil)
		tests = LoadTests(userId, section)

		# Creates 2-d Array grouped by subject
		# e.g. { "Math" = [[PreAlgebra1, PreAlgebra2], [Trig1, Trig2]]}
		testsArray = tests.group_by{|x|x.subject}.values

		return testsArray
	end

	def LoadTests(userId, section=nil)
		if (section)
			return GlobalPracticeTest.where(:section => section)
					.order("semester,name")
					.map{|t| PracticeTest.new(userId, t) }
		else
			return GlobalPracticeTest.order("semester, name, section")
					.map{|t| PracticeTest.new(userId, t) }
		end
	end
	
	def LoadUserTests(userId)
		return UserPracticeTest.where(:user_id => userId)
	end
end
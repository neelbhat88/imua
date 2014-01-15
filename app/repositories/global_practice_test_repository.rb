class GlobalPracticeTestRepository
	def initialize()		
	end

	def LoadTestsAsArray(section=nil)
		tests = LoadTests(section)		
		# Creates 2-d Array grouped by subject
		# e.g. { "Math" = [[PreAlgebra1, PreAlgebra2], [Trig1, Trig2]]}
		testsArray = tests.group_by{|x|x.subject}.values

		return testsArray
	end

	def LoadTests(section=nil)
		if (section)
			GlobalPracticeTest.where(:section => section).order("semester,name")
		else
			GlobalPracticeTest.order("semester, name, section")
		end
	end
end
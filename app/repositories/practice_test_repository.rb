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
		return UserPracticeTest.where("user_id = ? and score > 0", userId)
	end

	def GetPercentCompletedInfo(userId)
		totalPracticeTests = LoadTests(userId)
    	userPracticeTests = LoadUserTests(userId)
    
    	percentComplete = (userPracticeTests.length.to_f / totalPracticeTests.length.to_f).round(2) # or '%.2f' % (number)
    	
    	return { :percentComplete_f => percentComplete, 
    			 :totalPracticeTests => totalPracticeTests.length, 
    			 :totalUserTests => userPracticeTests.length
    			}
	end

	def GetPracticeTests(userId)
		actMathTests = LoadTestsAsArray(userId, "Math")
    	actReadingTests = LoadTestsAsArray(userId, "Reading")
    	actEnglishTests = LoadTestsAsArray(userId, "English")
    	actScienceTests = LoadTestsAsArray(userId, "Science")
    	
    	percentCompleteInfo = GetPercentCompletedInfo(userId)

    	practiceTests = PracticeTests.new
    	practiceTests.mathTests = actMathTests
    	practiceTests.readingTests = actReadingTests
    	practiceTests.englishTests = actEnglishTests
    	practiceTests.scienceTests = actScienceTests
    	practiceTests.totalTests = percentCompleteInfo[:totalPracticeTests]
    	practiceTests.totalUserTests = percentCompleteInfo[:totalUserTests]
    	practiceTests.percentComplete = percentCompleteInfo[:percentComplete_f] * 100

    	return practiceTests
	end

	def CreateUserTest(user, testId, semester, score)
		userTest = user.user_practice_tests.create(:global_practice_test_id=>testId, :semester=>semester, :score=>score)

		return userTest
	end

	def UpdateUserTest(user, userTestId, semester, score)
		userTest = user.user_practice_tests.find(userTestId)

    	userTest.update_attributes(:score => score, :semester=>semester)

    	return userTest
	end
end
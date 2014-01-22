class PracticeTest
	attr_accessor :id, :name, :semester, :section, :subject, 
				  :userTestId, :score, :editing

	def initialize(userId, practiceTest)
		@id = practiceTest.id
		@name = practiceTest.name
		@semester = practiceTest.semester
		@section = practiceTest.section
		@subject = practiceTest.subject
		
		@userTestId = nil
		@score = nil

		@editing = false

		userTest = practiceTest.user_practice_tests.where(:user_id => userId)		
		if (userTest.length > 0)
			if (userTest.length > 1) 
				Rails.logger.error("UserId #{userId} has more than 1 practice test for global_practice_test_id: #{practiceTest.id}")
			end

			@score = userTest[0].score
			@userTestId = userTest[0].id
		end
	end
end
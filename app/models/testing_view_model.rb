class TestingViewModel
	attr_accessor :name, :date, :score, :dbid

	def initialize(test)
		@name = test.global_exam.name
		@date = test.date.strftime("%m/%d/%Y")
		@score = test.score

		@global_exam_id = test.global_exam_id
		@dbid = test.id
	end
end
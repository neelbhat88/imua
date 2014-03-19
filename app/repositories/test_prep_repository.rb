class TestPrepRepository
	def initialize
	end

	def LoadAllSubjects()
		#return TestPrepSubject.all		
		subjects = []
		TestPrepSubject.all.each do |s|
			subjects << TestSubject.new(s)
		end

		return subjects
	end

	def CreateSubject(name)
		subject = TestPrepSubject.create(:name => name)

		return TestSubject.new(subject)
	end 

	def CreateCategory(subjectName, name, level)
		category = TestPrepSubject.find_by_name(subjectName).test_prep_categories.create(:name => name, :level => level)

		return TestCategory.new(category)
	end

	def CreateSubCategory(categoryName, name, description, level)
		subCategory = TestPrepCategory.find_by_name(categoryName).test_prep_sub_categories.create(:name => name, :description => description, :level => level)

		return TestSubCategory.new(subCategory)
	end

	def CreateQuestion(subCategoryName, questionText, solutionUrl)
		question = TestPrepSubCategory.find_by_name(subCategoryName).test_prep_questions.create(:question_text => questionText, :solution_url => solutionUrl)

		return TestQuestion.new(question)
	end
end

class TestSubject
	attr_accessor :id, :name, :TestCategories

	def initialize(subject)
		@id = subject.id
		@name = subject.name

		@TestCategories = []
		subject.test_prep_categories.order("level").each do |c|
			@TestCategories << TestCategory.new(c)
		end		 
	end
end

class TestCategory
	attr_accessor :id, :name, :level, :TestSubCategories

	def initialize(category)
		@id = category.id
		@name = category.name
		@level = category.level
		@TestSubCategories = []
		category.test_prep_sub_categories.order("level").each do |sc|
			@TestSubCategories << TestSubCategory.new(sc)
		end
	end
end

class TestSubCategory
	attr_accessor :id, :name, :level, :description, :TestQuestions

	def initialize(subCategory)
		@id = subCategory.id
		@name = subCategory.name
		@description = subCategory.description
		@level = subCategory.level

		@TestQuestions = []
		subCategory.test_prep_questions.each do |q|
			@TestQuestions << TestQuestion.new(q)
		end
	end
end

class TestQuestion
	attr_accessor :id, :questionText, :solutionUrl

	def initialize(question)
		@id = question.id
		@questionText = question.question_text
		@solutionUrl = question.solution_url
	end
end
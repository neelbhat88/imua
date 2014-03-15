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
end

class TestSubject
	attr_accessor :name, :TestCategories

	def initialize(subject)
		@name = subject.name

		@TestCategories = []
		subject.test_prep_categories.order("level").each do |c|
			@TestCategories << TestCategory.new(c)
		end		 
	end
end

class TestCategory
	attr_accessor :name, :level, :TestSubCategories

	def initialize(category)
		@name = category.name
		@level = category.level
		@TestSubCategories = []
		category.test_prep_sub_categories.order("level").each do |sc|
			@TestSubCategories << TestSubCategory.new(sc)
		end
	end
end

class TestSubCategory
	attr_accessor :name, :level, :description

	def initialize(subCategory)
		@name = subCategory.name
		@description = subCategory.description
		@level = subCategory.level
	end
end
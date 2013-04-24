class ClassViewModel
	attr_accessor :name, :level, :grade, :dbid

	def initialize(userclass)		
		@name = userclass.name
		@level = userclass.level
		@grade = userclass.grade
		@dbid = userclass.id
	end	
end
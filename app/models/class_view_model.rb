class ClassViewModel
	attr_accessor :name, :level, :grade, :dbid, :school_class_id

	def initialize(userclass)		
		@name = userclass.school_class.name
		@level = userclass.school_class.level
		@grade = userclass.grade
		@school_class_id = userclass.school_class.id
		
		@dbid = userclass.id
	end	
end
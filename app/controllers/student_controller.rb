class StudentController < ApplicationController
  def index
	user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i

  	student = StudentRepository.new().LoadStudent(user, semester)

  	@dataModel = {:Student => student }
  end
end

class StudentRepository
	def initialize
	end

	def LoadStudent(user, semester)
		student = Student.new
	  	student.first_name = user.first_name
	  	student.last_name = user.last_name

	  	student.Academics = Academics.new
	  	student.Academics.semester_gpa = AcademicsRepository.new(user).GetSemesterGpa(semester)
	  	student.Academics.badges = BadgeFactory.new(user).GetBadges(semester, "Academics")
                                             .map{|b| BadgeViewModel.new(b) }

	  	return student
	end
end

class Student
	attr_accessor :first_name, :last_name, :Academics

	def initialize
	end
end

class Academics
	attr_accessor :semester_gpa, :badges

	def initialize
	end
end
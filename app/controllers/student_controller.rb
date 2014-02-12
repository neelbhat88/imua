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
	  	#student.points_earned = student.badges.points_earned
	  	student.badges = BadgeFactory.new(user).GetBadges(semester).map{|b| BadgeViewModel.new(b) }

	  	student.Academics = Academics.new
	  	student.Academics.semester_gpa = AcademicsRepository.new(user).GetSemesterGpa(semester)	  	
	  	
	  	student.Extracurriculars = Extracurriculars.new
	  	student.Extracurriculars.total_activities = user.user_activities.where(:semester => semester).length	  	

     	student.Service = Service.new
	  	student.Service.total_hours = user.user_services.where(:semester => semester).sum(:hours)	  	

		student.PDU = PDU.new
	  	student.PDU.total_pdus = user.user_pdus.where(:semester => semester).length	  	

		student.Testing = Testing.new
	  	student.Testing.percent_complete = (PracticeTestRepository.new.GetPercentCompletedInfo(user.id)[:percentComplete_f] * 100).to_i	  	

	  	return student
	end
end

class Student
	attr_accessor :first_name, :last_name, :points_earned, :badges,
				  :Academics, :Extracurriculars, :Service, :PDU, :Testing

	def initialize
	end
end

class Academics
	attr_accessor :semester_gpa

	def initialize
	end
end

class Extracurriculars
	attr_accessor :total_activities

	def initialize
	end
end

class Service
	attr_accessor :total_hours

	def initialize
	end
end

class PDU
	attr_accessor :total_pdus

	def initialize
	end
end

class Testing
	attr_accessor :percent_complete

	def initialize
	end
end
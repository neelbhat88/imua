class StudentController < ApplicationController
  def index
	user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i

  	studentDashboard = StudentRepository.new().LoadStudentDashboard(user, semester)

  	@dataModel = {:StudentDashboard => studentDashboard }
  end
end

class StudentRepository
	attr_reader :userBadgeRepo, :academicsRepo, :practiceTestRepo, :badgeFactory, :toDoItemRepo

	def initialize(userBadgeRepo=UserBadgeRepository.new, academicsRepo=AcademicsRepository.new, practiceTestRepo=PracticeTestRepository.new, badgeFactory=BadgeFactory.new, toDoItemRepo=ToDoItemRepository.new)
		@userBadgeRepo = userBadgeRepo
		@academicsRepo = academicsRepo
		@practiceTestRepo = practiceTestRepo
		@badgeFactory = badgeFactory
		@toDoItemRepo = toDoItemRepo
	end	

	def LoadStudentDashboard(user, semester)
		sd = StudentDashboard.new
		sd.user_id = user.id
		sd.first_name = user.first_name
		sd.last_name = user.last_name

		sd.badges = @badgeFactory.GetBadges(:user => user, :semester => semester).map{|b| BadgeViewModel.new(b) }
	  	sd.semester_gpa = @academicsRepo.GetSemesterGpa(user, semester)	  		  	
	  	sd.total_activities = user.user_activities.where(:semester => semester).length	  	
	  	sd.total_hours = user.user_services.where(:semester => semester).sum(:hours)	  			
	  	sd.total_pdus = user.user_pdus.where(:semester => semester).length	  	
	  	sd.percent_complete = (@practiceTestRepo.GetPercentCompletedInfo(user.id)[:percentComplete_f] * 100).to_i
	  	sd.points_earned = @userBadgeRepo.GetScholarshipPointsEarned(user, semester)

	  	sd.to_do_items = @toDoItemRepo.GetItemsAssignedToUser(user)

		return sd
	end
end

class Dashboard
	attr_accessor :user_id, :first_name, :last_name

	def initialize
	end
end

class StudentDashboard < Dashboard
	attr_accessor :points_earned, :badges,
				  :semester_gpa, :total_activities, :total_hours, :total_pdus, :percent_complete,
				  :to_do_items

	def initialize
		super
	end
end
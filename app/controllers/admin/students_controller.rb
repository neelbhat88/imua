class Admin::StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only
  
  def index
    allstudents = User.LoadStudentsBySchoolId(current_user.user_info.school_id)
    
    studentsviewmodel = []
    allstudents.each do | student |
    	studentsviewmodel << AdminStudentsViewModel.new(student)
    end

    respond_to do |format|
  		format.json { render :json => 
  								{
  									:students => studentsviewmodel
  								} 
  					}
  		format.html # index.html.erb
  	end
  end
end
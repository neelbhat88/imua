class Admin::StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only
  
  def index

  end

  def init
    allstudents = User.LoadStudentsBySchoolId(current_user.user_info.school_id)
    
    # ToDo: Do this better!
    studentsviewmodel2016 = []
    allstudents.select {|s| s.user_info.classof == 2016}.each do | student |
      studentsviewmodel2016 << AdminStudentsViewModel.new(student)
    end

    studentsviewmodel2017 = []
    allstudents.select {|s| s.user_info.classof == 2017}.each do | student |
      studentsviewmodel2017 << AdminStudentsViewModel.new(student)
    end

    respond_to do |format|
      format.json { render :json => 
                  {
                    :students2016 => studentsviewmodel2016,
                    :students2017 => studentsviewmodel2017
                  } 
            }
    end
  end

  def progress
    @category = params[:page].to_s
    @user_id = params[:id]
    
    @student = User.find(params[:id])
  end
end
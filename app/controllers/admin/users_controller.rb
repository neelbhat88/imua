class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only

  def index
    @users = User.where(:role => 0).order("last_name ASC")
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.role = 0
    @school_id = params[:school][:id]
    @classof = params[:user_info][:classof].to_i

    if @user.save
      @user.create_user_info(:school_id => @school_id, :classof => @classof)
      
      # Init Semester GPA
      AcademicsRepository.new(@user).SaveTotalSemesterGpa(@user.user_info.current_semester)

      redirect_to admin_users_path, notice: 'Student was successfully created.'
    else
      render 'admin/users/new', alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @user = User.find(params[:id])
    @user_info = @user.user_info
    @semesters = (1..8).to_a

  end

  def update
    @user = User.find(params[:id])
    @user_info = @user.user_info
    @semesters = (1..8).to_a

    if @user.update_with_password(params[:user])            
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      render 'edit'
    end
  end

  def update_info
    @user_info = UserInfo.find(params[:id])
    user = @user_info.user

    if @user_info.update_attributes(params[:user_info])
      # Init Semester GPA
      AcademicsRepository.new(user).SaveTotalSemesterGpa(params[:user_info][:current_semester])
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      render :edit
    end

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_path
  end
end

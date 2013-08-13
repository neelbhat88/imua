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

    if @user.save
      @user.create_user_info(:school_id => @school_id)
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
    @user_info.school_id = params[:school][:id]

    if @user.update_with_password(params[:user])
      @user_info.save
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      render 'edit'
    end
  end

  def update_info
    @user_info = UserInfo.find(params[:id])

    if @user_info.update_attributes(params[:user_info])
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      render :edit
    end

  end

  def update_class
    @user_class = UserClass.find(params[:id])

    if @user_class.update_attributes(params[:user_info])
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

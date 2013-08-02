class Admin::UsersController < ApplicationController
  def index
    @users = User.where(:role => 0)
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
  end

  def update
    @user = User.find(params[:id])

    if @user.update_with_password(params[:user])
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      redirect_to admin_users_path
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

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_path
  end
end

class Admin::UserServicesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user_services = @user.user_services.where('semester = ?', @user.user_info.current_semester)
  end

  def show
    @user_service = UserService.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @user_service = UserService.new

  end

  def create
    @user_service = UserService.new(params[:user_service])

    if @user_service.save
      redirect_to admin_users_path, notice: 'Student classes were successfully updated.'
    else
      render 'admin/user_services/new', alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @user_service = UserService.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    @user_service = UserService.find(params[:id])

    if @user_service.update_attributes(params[:user_service])
      redirect_to admin_users_path, notice: 'Student was successfully updated.'
    else
      redirect_to admin_users_path
    end
  end


  def destroy
    @user_service = UserService.find(params[:id])
    @user_service.destroy

    redirect_to admin_users_path
  end
end

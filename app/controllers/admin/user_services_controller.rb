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
    @user_service.date = Date.strptime(params[:user_service][:date],'%m/%d/%Y')

    if @user_service.save
      # Trigger badge rules
      BadgeProcessor.new(current_user).CheckSemesterServices()

      redirect_to admin_user_services_path(:user_id => current_user.id), notice: 'Student classes were successfully updated.'
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
    @user_service.date = Date.strptime(params[:user_service][:date],'%m/%d/%Y')
    @user_service.name = params[:user_service][:name]
    @user_service.hours = params[:user_service][:hours]
    if @user_service.save
      # Trigger badge rules
      BadgeProcessor.new(current_user).CheckSemesterServices()

      redirect_to admin_user_services_path(:user_id => current_user.id), notice: 'Student was successfully updated.'
    else
      redirect_to admin_user_services_path(:user_id => current_user.id)
    end
  end


  def destroy
    @user_service = UserService.find(params[:id])
    @user_service.destroy

    # Trigger badge rules
    BadgeProcessor.new(current_user).CheckSemesterServices()

    redirect_to admin_user_services_path(:user_id => current_user.id)
  end
end

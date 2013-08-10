class Admin::UserActivitiesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user_activities = @user.user_activities.where('semester = ?', @user.user_info.current_semester)
  end

  def show
    @user_activity = UserActivity.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @user_activity = UserActivity.new

  end

  def create
    @user_activity = UserActivity.new(params[:user_activity])

    if @user_activity.save
      redirect_to admin_user_activities_path(:user_id => current_user.id), notice: 'Student classes were successfully updated.'
    else
      render 'admin/user_activities/new', alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @user_activity = UserActivity.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    @user_activity = UserActivity.find(params[:id])

    if @user_activity.update_attributes(params[:user_activity])
      redirect_to admin_user_activities_path(:user_id => current_user.id), notice: 'Student was successfully updated.'
    else
      redirect_to admin_user_activities_path(:user_id => current_user.id)
    end
  end


  def destroy
    @user_activity = UserActivity.find(params[:id])
    @user_activity.destroy

    redirect_to admin_user_activities_path(:user_id => current_user.id)
  end
end

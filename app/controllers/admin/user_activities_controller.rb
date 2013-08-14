class Admin::UserActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only

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
    @user = User.find(@user_activity.user_id)

    if (params[:user_activity][:leadership_title] == "")
      @user_activity.leadership_held = false
    else
      @user_activity.leadership_held = true
    end

    if @user_activity.save
      # Trigger badge rules
      BadgeProcessor.new(@user).CheckSemesterActivities()

      redirect_to admin_user_activities_path(:user_id => @user.id), notice: 'Student classes were successfully updated.'
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
    @user = User.find(@user_activity.user_id)

    if (params[:user_activity][:leadership_title] == "")
      @user_activity.leadership_held = false
    else
      @user_activity.leadership_held = true
    end

    if @user_activity.update_attributes(params[:user_activity])
      # Trigger badge rules
      BadgeProcessor.new(@user).CheckSemesterActivities()

      redirect_to admin_user_activities_path(:user_id => @user.id), notice: 'Student was successfully updated.'
    else
      redirect_to admin_user_activities_path(:user_id => @user.id)
    end
  end


  def destroy
    @user_activity = UserActivity.find(params[:id])
    @user_activity.destroy
    @user = User.find(@user_activity.user_id)

    # Trigger badge rules
    BadgeProcessor.new(@user).CheckSemesterActivities()

    redirect_to admin_user_activities_path(:user_id => @user.id)
  end
end

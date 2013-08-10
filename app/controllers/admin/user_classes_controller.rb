class Admin::UserClassesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user_classes = @user.user_classes.where('semester = ?', @user.user_info.current_semester)
  end

  def show
    @user_class = UserClass.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @user_class = UserClass.new
    set_grade_options
  end

  def create
    @user_class = UserClass.new(params[:user_class])
    @user_class.name = set_class_name

    if @user_class.save
      redirect_to admin_user_classes_path(:user_id => current_user.id), notice: 'Student classes were successfully updated.'
    else
      render 'admin/user_classes/new', alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @user_class = UserClass.find(params[:id])
    @user = User.find(params[:user_id])
    set_grade_options
  end

  def update
    @user_class = UserClass.find(params[:id])
    @user_class.name = set_class_name

    if @user_class.update_attributes(params[:user_class])
      redirect_to admin_user_classes_path(:user_id => current_user.id), notice: 'Student was successfully updated.'
    else
      redirect_to admin_user_classes_path(:user_id => current_user.id)
    end
  end


  def destroy
    @user_class = UserClass.find(params[:id])
    @user_class.destroy

    redirect_to admin_user_classes_path(:user_id => current_user.id)
  end

  private
    def set_grade_options
      @grade_options = ["A","A-","B+","B","B-","C+","C","C-","D","F"]
    end

    def set_class_name
      return SchoolClass.where(:id => @user_class.school_class_id).first.name
    end
end

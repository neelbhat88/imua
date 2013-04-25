class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin_only
  	redirect_to root_url unless current_user.is_admin?
  end

  def teacher_only
  	redirect_to root_url unless (current_user.is_admin? || current_user.is_teacher?)
  end
end

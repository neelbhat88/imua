class ApplicationController < ActionController::Base
	protect_from_forgery

	def admin_only
		redirect_to root_url unless current_user.is_admin?
	end

	def teacher_only
		redirect_to root_url unless (current_user.is_admin? || current_user.is_teacher?)
	end

	def after_sign_in_path_for(resource)
		if current_user.is_student?
			return global_badges_path
		elsif current_user.is_teacher?
			return admin_users_path
		end

		return school_classes_path
	end

end

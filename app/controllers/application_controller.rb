class ApplicationController < ActionController::Base
	after_filter :no_cache

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
			return admin_students_path
		end

		return super_admin_dashboard_path
	end

	private

		def no_cache
			# Don't cache AJAX requests so pressing back button does not show json
			# http://stackoverflow.com/questions/7734427/rails-3-1-is-returning-raw-javascript-code-when-back-button-is-used			
			response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
			response.headers["Pragma"] = "no-cache"
			response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"			
		end
end

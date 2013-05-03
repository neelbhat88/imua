class RegistrationsController < Devise::RegistrationsController
	def new
		@role = params[:role] == nil ? 0 : params[:role]

		super		
	end

	def create
		@role = params[:user][:role] == nil ? 0 : params[:role]
		@email = params[:user][:email]
		@school_id = params[:school][:id]

		# This is super hacky but can't think of a better way right now
		num_before = User.all.length
		logger.debug("DEBUG: Users before #{num_before}, role = #{@role}, school = #{@school_id}, email = #{@email}")

		super

		logger.debug("DEBUG: After create")
		num_after = User.all.length
		logger.debug("DEBUG: Users after #{num_after}")

		if num_after > num_before
			User.find_by_email(params[:user][:email]).create_user_info(:school_id => @school_id)
		end
	end

	def update
		@role = params[:role] == nil ? 0 : params[:role]
		@school_id = params[:school][:id]

		super
	end
end

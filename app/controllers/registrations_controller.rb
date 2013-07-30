class RegistrationsController < Devise::RegistrationsController
before_filter :authenticate_user!

	def new
		@role = params[:role] == nil ? 0 : params[:role]

		super
	end

	def create
		@role = params[:user][:role] == nil ? 0 : params[:user][:role]
		@first_name = params[:user][:first_name]
		@last_name = params[:user][:last_name]
		@email = params[:user][:email]
		@school_id = params[:school][:id]

		# This is super hacky but can't think of a better way right now
		num_before = User.all.length
		logger.debug("DEBUG: Users before #{num_before}, role = #{@role}, school = #{@school_id}, email = #{@email}")

		super

		logger.debug("DEBUG: After create")
		num_after = User.all.length
		logger.debug("DEBUG: Users after #{num_after}")

		# Add to user_info only if saved successfully
		if num_after > num_before
			User.find_by_email(params[:user][:email]).create_user_info(:school_id => @school_id)
		end
	end

	def update
		@role = params[:user][:role] == nil ? 0 : params[:user][:role]
		@school_id = params[:school][:id]

		super
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	protected
		def after_update_path_for(resource)
	  	show_user_registration_path(resource)
		end

end

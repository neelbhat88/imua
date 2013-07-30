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
		@user = current_user
		@user.update_attributes(params[:user])
		@user.role = params[:user][:role] == nil ? 0 : params[:user][:role]
		# @school_id = params[:school][:id]
		if @user.save
			redirect_to show_user_registration_path(current_user), :notice => "Your information was updated successfully!"
		else
			redirect_to :back, :notice => "Something went wrong and your information was not updated successfully."
		end
	end

	def show
		@user = User.find(params[:id])
	end

end

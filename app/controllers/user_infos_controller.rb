class UserInfosController < ApplicationController

  def edit
    @user_info = current_user.user_info
  end

  def update
    @user_info = current_user.user_info

    @user_info.update_attributes(params[:user_info])

    if @user_info.save
      redirect_to show_user_registration_path(current_user), :notice => "Your information was successfully updated."
    else
      render 'edit', :notice => 'Sorry, your information was not successfully saved.'
    end
  end


end

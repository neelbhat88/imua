class Admin::UserPdusController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @user_pdus = @user.user_pdus.where('semester = ?', @user.user_info.current_semester)
  end

  def show
    @user_pdu = UserPdu.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @user_pdu = UserPdu.new

  end

  def create
    @user_pdu = UserPdu.new(params[:user_pdu])
    @user_pdu.date = Date.strptime(params[:user_pdu][:date],'%m/%d/%Y')

    if @user_pdu.save
      redirect_to admin_user_pdus_path(:user_id => current_user.id), notice: 'Student classes were successfully updated.'
    else
      render 'admin/user_pdus/new', alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def edit
    @user_pdu = UserPdu.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    @user_pdu = UserPdu.find(params[:id])
    @user_pdu.date = Date.strptime(params[:user_pdu][:date],'%m/%d/%Y')
    @user_pdu.school_pdu_id = params[:user_pdu][:school_pdu_id]
    @user_pdu.hours = params[:user_pdu][:hours]
    if @user_pdu.save
      redirect_to admin_user_pdus_path(:user_id => current_user.id), notice: 'Student was successfully updated.'
    else
      redirect_to admin_user_pdus_path(:user_id => current_user.id)
    end
  end


  def destroy
    @user_pdu = UserPdu.find(params[:id])
    @user_pdu.destroy

    redirect_to admin_user_pdus_path(:user_id => current_user.id)
  end
end

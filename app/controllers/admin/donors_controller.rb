class Admin::DonorsController < ApplicationController
  def index
    @donors = Donor.all
    @donor = Donor.new
  end

  def create
    @donor = Donor.new(params[:donor])

    if @donor.save
      redirect_to admin_donors_path, notice: 'Donor was successfully created.'
    else
      redirect_to  admin_donors_path, alert: 'Sorry, something went wrong. Try again.'
    end
  end

  def destroy
    @donor = Donor.find(params[:id])
    @donor.destroy

    redirect_to admin_donors_url
  end
end

class StaticPagesController < ApplicationController
  def home
  end

  def students
  	@students = User.where(:role => 0)
    @title = "Our Students"
  end

  def donors
  	@donors = Donor.all
  end

  def profile
  end

  def summary
  end
end

class StaticPagesController < ApplicationController
  def home
  end

  def students
  	@students = Student.all
  end

  def donors
  	@donors = Donor.all
  end

  def profile
  end

  def summary
  end
end

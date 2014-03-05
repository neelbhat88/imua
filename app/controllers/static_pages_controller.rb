class StaticPagesController < ApplicationController
  def home
  end

  def students
    # ToDo: Putting this in to quickly solve our test users from showing up on Students page.
    #  If needed remove this for a better solution (a Test flag maybe?)
  	@students = User.where("role = 50 and email not like ? and email not like ?", "%neelbhat88%", "%mcassid3%").order("last_name")
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

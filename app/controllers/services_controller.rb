class ServicesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  	respond_to do |format|
  		format.html { render :layout => false } # index.html.erb
  	end
  end

  def init
    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
    isTeacher = params[:isTeacher]

    allservices = user.user_services.where('semester = ?', semester).order("date DESC")

    services = []
    allservices.each do | a |
      services << ServiceViewModel.new(a)
    end   

    badgesviewmodel =  BadgeFactory.new.GetBadges(:user => user, :semester => semester, :category => "Service")
                                             .map{|b| BadgeViewModel.new(b) }

    respond_to do |format|
      format.json { render :json => 
                            {
                              :userservices => services, 
                              :badges => badgesviewmodel,
                              :editable => isTeacher == 'true' || (semester == current_user.user_info.current_semester),
                              :semesters => (1..user.user_info.current_semester).to_a,
                              :init_semester =>user.user_info.current_semester
                            } 
                  }
    end
  end

  def saveServices
    ##################################################
	  # ---------------- Services ----------------------
    ##################################################
    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
  	servicesJson = JSON.parse(params[:services])
  	removeJson = JSON.parse(params[:toRemove])

  	# Add or Edit
  	servicesJson.each do | c |  		
  		if c["dbid"] == ""  				        
	        user.user_services.create(:name =>c["name"],
	        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
	        								  :hours=>c["hours"],
	        								  :semester=>semester
	        								 )
  		else
  			toEdit = user.user_services.find(c["dbid"].to_i)

      	toEdit.update_attributes(:name =>c["name"],
        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
        								  :hours=>c["hours"]
      									)
		  end
  	end

  	# Remove
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			user.user_services.find(r["dbid"].to_i).destroy
  		end
  	end

  	# Reload all
  	allservices = user.user_services.where('semester = ?', semester).order("date DESC")

    returnservices = []
    allservices.each do | a |		
    	returnservices << ServiceViewModel.new(a)
    end

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################   
    # Don't need this since this is calculated by the badge itself
    totalHours = params[:totalHours]

    BadgeProcessor.new.CheckSemesterServices(user, semester)

    # Reload badges
    badgesviewmodel =  BadgeFactory.new.GetBadges(:user => user, :semester => semester, :category => "Service")
                                             .map{|b| BadgeViewModel.new(b) }

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newservices => returnservices, :badges => badgesviewmodel} }
    end
  end
end

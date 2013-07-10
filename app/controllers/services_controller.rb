class ServicesController < ApplicationController
  def index
  	allservices = current_user.user_services.where('semester = ?', current_user.user_info.current_semester).order("date DESC")

  	services = []
  	allservices.each do | a |
  		services << ServiceViewModel.new(a)
  	end   

  	respond_to do |format|
  		format.json { render :json => {:userservices => services} }
  		format.html # index.html.erb
  	end
  end

  def saveServices
    ##################################################
	# ---------------- Services ----------------------
    ##################################################
  	servicesJson = JSON.parse(params[:services])
  	removeJson = JSON.parse(params[:toRemove])

  	logger.debug "DEBUG: Services - #{servicesJson}"
  	logger.debug "DEBUG: To Remove - #{removeJson}"  

  	# Add or Edit
  	servicesJson.each do | c |  		
  		if c["dbid"] == ""  			
	        logger.debug "DEBUG: New UserService Name = #{c["name"]}, date = #{c["date"]} hours = #{c["hours"]} }"
	        
	        current_user.user_services.create(:name =>c["name"],
	        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
	        								  :hours=>c["hours"],
	        								  :semester=>current_user.user_info.current_semester,
	        								 )
  		else
  			toEdit = current_user.user_services.find(c["dbid"].to_i)
  			logger.debug "DEBUG: Existing UserService id = #{c["dbid"]} date = #{c["date"]}"

        	toEdit.update_attributes(:name =>c["name"],
	        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
	        								  :hours=>c["hours"]
        									)
		end
  	end

  	# Remove
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			logger.debug "DEBUG: Removing service with id = #{r["dbid"]}"
  			current_user.user_services.find(r["dbid"].to_i).destroy
  		end
  	end

  	# Reload all
  	allservices = current_user.user_services.where('semester = ?', current_user.user_info.current_semester).order("date DESC")  	

    returnservices = []
    allservices.each do | a |		
    	returnservices << ServiceViewModel.new(a)
    end

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################   
    totalHours = params[:totalHours]

    # badgeProcessor = BadgeProcessor.new(current_user)
    # newBadgeCount = badgeProcessor.CheckSemesterServices()
  	
  	logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newservices => returnservices} }
    end
  end
end
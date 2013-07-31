class ActivitiesController < ApplicationController
  def index
  	allactivities = current_user.user_activities.where('semester = ?', current_user.user_info.current_semester).order("id")

  	activities = []
  	allactivities.each do | a |
  		activities << ActivityViewModel.new(a)
  	end

    # Get all global activities to put into dropdown
    globalactivities = SchoolActivity.where('school_id = ?', current_user.user_info.school_id).select([:id, :name]).order("name")

  	respond_to do |format|
  		format.json { render :json => {:useractivities => activities, :globalactivities => globalactivities} }
  		format.html { render :layout => false } # index.html.erb
  	end
  end

  def saveActivities
    ##################################################
	# ---------------- Activities --------------------
    ##################################################
  	activitiesJson = JSON.parse(params[:activities])
  	removeJson = JSON.parse(params[:activitiesToRemove])

  	logger.debug "DEBUG: Activities - #{activitiesJson}"
  	logger.debug "DEBUG: ActivitiesToRemove - #{removeJson}"  

  	# Add or Edit
  	activitiesJson.each do | c |  		
  		if c["dbid"] == ""  			
	        logger.debug "DEBUG: New UserActivity school_activity_id = #{c["school_activity_id"]}, description = #{c["description"]} }"
	        
	        description = []
	        descriptionArray = c["description"]
	        descriptionArray.each do | d |
	        	description << d["text"]
	        end
	        
	        current_user.user_activities.create(:school_activity_id =>c["school_activity_id"].to_i, 
	        									:leadership_held=>c["leadershipHeld"], 
	        									:leadership_title=>c["leadershipTitle"],
	        									:semester=>current_user.user_info.current_semester,
	        									:description=>description.join("|")
	        									)
  		else
  			activityToEdit = current_user.user_activities.find(c["dbid"].to_i)
  			logger.debug "DEBUG: Existing UserActivity id = #{c["dbid"]}"
        	#logger.debug "DEBUG: Old values activity_class_id = #{activityToEdit.school_class_id}, Grade #{classToEdit.grade}"
  			
  			description = []
	        descriptionArray = c["description"]
	        descriptionArray.each do | d |
	        	description << d["text"]
	        end

        	activityToEdit.update_attributes(:school_activity_id => c["school_activity_id"].to_i,
        									 :leadership_held=>c["leadershipHeld"], 
        									 :leadership_title=>c["leadershipTitle"],        									 
        									 :description=>description.join("|")
        									)
        	#logger.debug "DEBUG: New values school_class_id = #{classToEdit.school_class_id}, Grade #{classToEdit.grade}"
		end
  	end

  	# Remove
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			logger.debug "DEBUG: Removing activity with id = #{r["dbid"]}"
  			current_user.user_activities.find(r["dbid"].to_i).destroy
  		end
  	end

  	# Reload all
  	allactivities = current_user.user_activities.where('semester = ?', current_user.user_info.current_semester).order("id")

    returnactivities = []
    allactivities.each do | a |		
    	returnactivities << ActivityViewModel.new(a)
    end

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################   

    badgeProcessor = BadgeProcessor.new(current_user)
    newBadgeCount = badgeProcessor.CheckSemesterActivities()
  	
  	logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newactivities => returnactivities} }
    end
  end
end

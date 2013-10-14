class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  	respond_to do |format|  		
  		format.html { render :layout => false } # index.html.erb
  	end
  end

  def init
    semester = params[:semester].to_i
    if semester == 0
      semester = current_user.user_info.current_semester
    end

    allactivities = current_user.user_activities.where('semester = ?', semester).order("id")

    activities = []
    allactivities.each do | a |
      activities << ActivityViewModel.new(a)
    end

    # Get all global activities to put into dropdown
    globalactivities = SchoolActivity.where('school_id = ?', current_user.user_info.school_id).select([:id, :name]).order("name")

    badges = GlobalBadge.where(:semester => [nil, semester], :category => "Activity")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user, semester)

    respond_to do |format|
      format.json { render :json => 
                              {
                                :useractivities => activities, 
                                :globalactivities => globalactivities,
                                :badges => badgesviewmodel,
                                :editable => (semester == current_user.user_info.current_semester),
                                :semesters => (1..current_user.user_info.current_semester).to_a,
                                :init_semester =>current_user.user_info.current_semester
                              } 
                  }
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
      if c["leadershipHeld"]
        leadershipTitle = c["leadershipTitle"]
      else
        leadershipTitle = ""
      end

  		if c["dbid"] == ""  			
	        logger.debug "DEBUG: New UserActivity school_activity_id = #{c["school_activity_id"]}, description = #{c["description"]} }"          
	        
	        description = []
	        descriptionArray = c["description"]
	        descriptionArray.each do | d |
	        	description << d["text"]
	        end
	        
	        current_user.user_activities.create(:school_activity_id =>c["school_activity_id"].to_i, 
	        									:leadership_held=>c["leadershipHeld"], 
	        									:leadership_title=>leadershipTitle,
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
        									 :leadership_title=>leadershipTitle,
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
    badgeObject = badgeProcessor.CheckSemesterActivities()
  	
  	logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

    # Reload badges
    badges = GlobalBadge.where(:semester => [nil, current_user.user_info.current_semester], :category => "Activity")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user)

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newactivities => returnactivities, :badges => badgesviewmodel } }
    end
  end
end

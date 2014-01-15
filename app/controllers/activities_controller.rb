class ActivitiesController < ApplicationController
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

    allactivities = user.user_activities.where('semester = ?', semester).order("id")

    activities = []
    allactivities.each do | a |
      activities << ActivityViewModel.new(a)
    end

    # Get all global activities to put into dropdown
    globalactivities = SchoolActivity.where('school_id = ?', user.user_info.school_id).select([:id, :name]).order("name")

    badges = GlobalBadgeRepository.new().LoadAllBadges(semester,"Activity")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

    respond_to do |format|
      format.json { render :json => 
                              {
                                :useractivities => activities, 
                                :globalactivities => globalactivities,
                                :badges => badgesviewmodel,
                                :editable => isTeacher == 'true' || (semester == user.user_info.current_semester),
                                :semesters => (1..user.user_info.current_semester).to_a,
                                :init_semester =>user.user_info.current_semester
                              } 
                  }
    end
  end

  def saveActivities
    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
    activitiesJson = JSON.parse(params[:activities])
    removeJson = JSON.parse(params[:activitiesToRemove])
    ##################################################
	  # ---------------- Activities --------------------
    ##################################################
  	# Add or Edit
  	activitiesJson.each do | c |
      if c["leadershipHeld"]
        leadershipTitle = c["leadershipTitle"]
      else
        leadershipTitle = ""
      end

  		if c["dbid"] == ""
	        description = []
	        descriptionArray = c["description"]
	        descriptionArray.each do | d |
	        	description << d["text"]
	        end
	        
	        user.user_activities.create(:school_activity_id =>c["school_activity_id"].to_i, 
	        									:leadership_held=>c["leadershipHeld"], 
	        									:leadership_title=>leadershipTitle,
	        									:semester=>semester,
	        									:description=>description.join("|")
	        									)
  		else
  			activityToEdit = user.user_activities.find(c["dbid"].to_i)
  			
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
		  end
  	end

  	# Remove
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			user.user_activities.find(r["dbid"].to_i).destroy
  		end
  	end

  	# Reload all
  	allactivities = user.user_activities.where('semester = ?', semester).order("id")

    returnactivities = []
    allactivities.each do | a |		
    	returnactivities << ActivityViewModel.new(a)
    end

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################   

    badgeProcessor = BadgeProcessor.new(user, semester)
    badgeObject = badgeProcessor.CheckSemesterActivities()

    # Reload badges
    badges = GlobalBadgeRepository.new().LoadAllBadges(semester,"Activity")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newactivities => returnactivities, :badges => badgesviewmodel } }
    end
  end
end

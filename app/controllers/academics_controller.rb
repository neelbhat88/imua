class AcademicsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_controller

  attr_accessor :academics_repo

  def index
    semester = params[:semester].to_i
    if semester == 0
      semester = current_user.user_info.current_semester
    end

  	allclasses = current_user.user_classes.where('semester = ?', semester)

  	classes = []
  	allclasses.each do | a |		
  		classes << ClassViewModel.new(a)
  	end

    # Get total semester gpa
    totalsemgpa = current_user.user_semester_gpas.where(:semester => semester).first.gpa

    # Get all global classes to put into dropdown
    globalclasses = SchoolClass.where('school_id = ?', current_user.user_info.school_id).select([:id, :name]).order("name")

    badges = GlobalBadge.where(:semester => [nil, semester], :category => "Academics")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user, semester)

  	respond_to do |format|
      format.json { render :json => 
                              {
                              :userclasses => classes, 
                              :globalclasses => globalclasses, 
                              :badges => badgesviewmodel, 
                              :totalsemgpa => totalsemgpa, 
                              :editable => (semester == current_user.user_info.current_semester),
                              :semesters => (1..current_user.user_info.current_semester).to_a,
                              :init_semester =>current_user.user_info.current_semester
                              } 
                  }
      format.html { render :layout=>false } # index.html.erb	
  	end
  end

  def saveClasses
    ##################################################
	  # ------------------ Classes ---------------------
    ##################################################
  	classesJson = JSON.parse(params[:classes])
  	removeJson = JSON.parse(params[:classesToRemove])

  	logger.debug "DEBUG: Classes - #{classesJson}"
  	logger.debug "DEBUG: ClassesToRemove - #{removeJson}"  

  	# Add or Edit classes
  	classesJson.each do | c |  		
  		if c["dbid"] == ""
  			#logger.debug "DEBUG: New UserClass id = #{c["dbid"]} name = #{c["name"]} grade = #{c["grade"]} level = #{c["level"]} }"
  			#current_user.user_classes.create(:name=>c["name"], :level=>c["level"], :grade=>c["grade"], :semester=>current_user.user_info.current_semester)
        logger.debug "DEBUG: New UserClass school_class_id = #{c["school_class_id"]} grade = #{c["grade"]} }"
        current_user.user_classes.create(:school_class_id =>c["school_class_id"].to_i, :grade=>c["grade"], :semester=>current_user.user_info.current_semester)
  		else
  			classToEdit = current_user.user_classes.find(c["dbid"].to_i)
  			logger.debug "DEBUG: Existing UserClass id = #{c["dbid"]}"
  			#logger.debug "DEBUG: Old values Name = #{classToEdit.name}, Level = #{classToEdit.level}, Grade #{classToEdit.grade}"  			
        logger.debug "DEBUG: Old values school_class_id = #{classToEdit.school_class_id}, Grade #{classToEdit.grade}"

  			#classToEdit.update_attributes(:name => c["name"], :level => c["level"], :grade => c["grade"])        
  			#logger.debug "DEBUG: New values Name = #{classToEdit.name}, Level = #{classToEdit.level}, Grade #{classToEdit.grade}"
        classToEdit.update_attributes(:school_class_id => c["school_class_id"].to_i, :grade => c["grade"])
        logger.debug "DEBUG: New values school_class_id = #{classToEdit.school_class_id}, Grade #{classToEdit.grade}"
		  end
  	end

  	# Remove classes
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			logger.debug "DEBUG: Removing class with id = #{r["dbid"]}"
  			current_user.user_classes.find(r["dbid"].to_i).destroy
  		end
  	end

    # Save total semester GPA
    totalsemgpa = self.academics_repo.SaveTotalSemesterGpa(current_user.user_info.current_semester)    

  	# Reload all classes
  	allclasses = UserClass.where('semester = ? and user_id = ?', current_user.user_info.current_semester, current_user.id)

    returnclasses = []
    allclasses.each do | a |		
    	returnclasses << ClassViewModel.new(a)
    end    

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################    
    badgeProcessor = BadgeProcessor.new(current_user)
    badgeObject = badgeProcessor.CheckSemesterAcademics()  

    # Reload badges
    badges = GlobalBadge.where(:semester => [nil, current_user.user_info.current_semester], :category => "Academics")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user)

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newclasses => returnclasses, :badges => badgesviewmodel, :totalsemgpa => totalsemgpa} }
    end
  end

  private
    def init_controller
      self.academics_repo = AcademicsRepository.new(current_user)
    end
end

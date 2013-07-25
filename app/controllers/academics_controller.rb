class AcademicsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	allclasses = current_user.user_classes.where('semester = ?', current_user.user_info.current_semester)

  	classes = []
  	allclasses.each do | a |		
  		classes << ClassViewModel.new(a)
  	end

    # Get all global classes to put into dropdown
    globalclasses = SchoolClass.where('school_id = ?', current_user.user_info.school_id).select([:id, :name]).order("name")

    #customers = Customer.find(:all,  rder => 'first_name').map{|x| [x.full_name] + [x.id]}

  	respond_to do |format|
  		format.json { render :json => {:userclasses => classes, :globalclasses => globalclasses} }
  		format.html # index.html.erb
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

  	# Reload all classes
  	allclasses = UserClass.where('semester = ? and user_id = ?', current_user.user_info.current_semester, current_user.id)

    returnclasses = []
    allclasses.each do | a |		
    	returnclasses << ClassViewModel.new(a)
    end

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################
    totalGpa = params[:totalGPA]
    logger.debug "DEBUG: TotalGPA - #{totalGpa}"

    badgeProcessor = BadgeProcessor.new(current_user)
    badgeObject = badgeProcessor.CheckSemesterAcademics()
  	
  	logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newclasses => returnclasses, :newbadgecount => badgeObject} }
    end
  end
end

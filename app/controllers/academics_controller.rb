class AcademicsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	respond_to do |format|
      format.html { render :layout=>false } # index.html.erb	
  	end
  end

  def init
    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i

    academicsRepository = AcademicsRepository.new(user)

    allclasses = academicsRepository.GetUserClassesBySemester(semester)

    classes = []
    allclasses.each do | a |    
      classes << ClassViewModel.new(a)
    end

    # Get total semester gpa
    totalsemgpa = academicsRepository.GetSemesterGpa(semester)

    # ToDo: Refactor these to not use Model directly
    # Get all global classes to put into dropdown
    globalclasses = SchoolClass.where('school_id = ?', user.user_info.school_id).select([:id, :name]).order("name")

    badges = GlobalBadge.where(:semester => [nil, semester], :category => "Academics")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

    respond_to do |format|
      format.json { render :json => 
                              {
                              :userclasses => classes, 
                              :globalclasses => globalclasses, 
                              :badges => badgesviewmodel, 
                              :totalsemgpa => totalsemgpa, 
                              :editable => (semester == current_user.user_info.current_semester),
                              # The following two can use current_user
                              :semesters => (1..current_user.user_info.current_semester).to_a,
                              :init_semester =>current_user.user_info.current_semester
                              } 
                  }
    end
  end

  def saveClasses    
    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
    classesJson = JSON.parse(params[:classes])
    removeJson = JSON.parse(params[:classesToRemove])

    academicsRepository = AcademicsRepository.new(user)
    
    ##################################################
	  # ------------------ Classes ---------------------
    ##################################################
  	# Add or Edit classes
  	classesJson.each do | c |  		
  		if c["dbid"] == ""      
        user.user_classes.create(:school_class_id =>c["school_class_id"].to_i, :grade=>c["grade"], :semester=>semester)
  		else
  			classToEdit = user.user_classes.find(c["dbid"].to_i)  			
        classToEdit.update_attributes(:school_class_id => c["school_class_id"].to_i, :grade => c["grade"])
		  end
  	end

  	# Remove classes
  	removeJson.each do | r |
  		if r["dbid"] != ""
  			user.user_classes.find(r["dbid"].to_i).destroy
  		end
  	end

    # Save total semester GPA
    totalsemgpa = '%.2f' % (academicsRepository.SaveTotalSemesterGpa(semester))

  	# Reload all classes
  	allclasses = academicsRepository.GetUserClassesBySemester(semester)

    returnclasses = []
    allclasses.each do | a |		
    	returnclasses << ClassViewModel.new(a)
    end    

    ##################################################
    # ------------------ BADGES ----------------------
    ##################################################    
    badgeProcessor = BadgeProcessor.new(user)
    badgeObject = badgeProcessor.CheckSemesterAcademics()  

    # Reload badges
    badges = GlobalBadge.where(:semester => [nil, semester], :category => "Academics")
    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user)

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newclasses => returnclasses, :badges => badgesviewmodel, :totalsemgpa => totalsemgpa} }
    end
  end

  private
    
end

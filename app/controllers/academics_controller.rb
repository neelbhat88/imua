class AcademicsController < ApplicationController
  before_filter :authenticate_user!

  def index
	allclasses = current_user.user_classes.where('semester = ?', current_user.user_info.current_semester)

	classes = []
	allclasses.each do | a |		
		classes << ClassViewModel.new(a)
	end

	respond_to do |format|
		format.json { render :json => classes }
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
  			logger.debug "DEBUG: New UserClass id = #{c["dbid"]} name = #{c["name"]} grade = #{c["grade"]} level = #{c["level"]} }"
  			current_user.user_classes.create(:name=>c["name"], :level=>c["level"], :grade=>c["grade"], :semester=>current_user.user_info.current_semester)
  		else
  			classToEdit = current_user.user_classes.find(c["dbid"].to_i)
  			logger.debug "DEBUG: Existing UserClass id = #{c["dbid"]}"
  			logger.debug "DEBUG: Old values Name = #{classToEdit.name}, Level = #{classToEdit.level}, Grade #{classToEdit.grade}"  			

  			classToEdit.update_attributes(:name => c["name"], :level => c["level"], :grade => c["grade"])
  			logger.debug "DEBUG: New values Name = #{classToEdit.name}, Level = #{classToEdit.level}, Grade #{classToEdit.grade}"
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

  	# Load all Academics-GPA badges
  	allBadges = GlobalBadge.where("category = 'Academics' and subcategory = 1 and semester = ?", current_user.user_info.current_semester)

  	# Call compare and pass in totalGPA
  	@newbadgecount = 0
  	allBadges.each do |b|
  		if b.Compare(totalGpa) == true && current_user.user_badges.find_by_global_badge_id(b.id) == nil
  			@newbadgecount += 1

  			# Save earned badge to db
  			current_user.user_badges.create(:global_badge_id => b.id)
  		end
  	end
  	logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

  	# Return new badges received
  	respond_to do |format|
  		format.json { render :json => { :newclasses => returnclasses, :newbadgecount => @newbadgecount} }
	end
  end
end

class TestingController < ApplicationController
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

		alltesting = user.user_testings.where('semester = ?', semester).order("date DESC")

	  	tests = []
	  	alltesting.each do | a |
	  		tests << TestingViewModel.new(a)
	  	end

	  	# Get all global exam to put into dropdown
    	globalexams = GlobalExam.select([:id, :name]).order("name")

    	badges = GlobalBadge.where(:semester => [nil, semester], :category => "Testing")
    	badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

    	practicetests = GlobalPracticeTest.where(:semester => semester)

	  	respond_to do |format|
	  		format.json { render :json => 
	  								{
	  									:usertests => tests, 
	  									:practicetests => practicetests,
	  									:globalexams => globalexams, 
	  									:badges => badgesviewmodel,
	  									:editable => isTeacher == 'true' || (semester == current_user.user_info.current_semester),
			                            :semesters => (1..user.user_info.current_semester).to_a,
			                        	:init_semester =>user.user_info.current_semester
	  								} 
	  					}
	  	end
	end

	def saveTesting
	    ##################################################
		# ---------------- Tests ----------------------
	    ##################################################
	    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    	semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
	  	testsJson = JSON.parse(params[:tests])
	  	removeJson = JSON.parse(params[:toRemove])	  

	  	# Add or Edit
	  	testsJson.each do | c |  		
	  		if c["dbid"] == ""		       
		        user.user_testings.create(:global_exam_id =>c["global_exam_id"],
        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
        								  :score=>c["score"],
        								  :semester=>semester,
        								 )
	  		else
	  			toEdit = user.user_testings.find(c["dbid"].to_i)

	        	toEdit.update_attributes(:global_exam_id =>c["global_exam_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
		        								  :score=>c["score"]
	        									)
			  end
	  	end

	  	# Remove
	  	removeJson.each do | r |
	  		if r["dbid"] != ""
	  			user.user_testings.find(r["dbid"].to_i).destroy
	  		end
	  	end

	  	# Reload all
	  	alltests = user.user_testings.where('semester = ?', semester).order("date DESC")

	    returntests = []
	    alltests.each do | a |		
	    	returntests << TestingViewModel.new(a)
	    end

	    ##################################################
	    # ------------------ BADGES ----------------------
	    ##################################################   	    
	    badgeProcessor = BadgeProcessor.new(user, semester)
	    badgeProcessor.CheckSemesterTesting()
	  		  	
	  	# Reload badges
	    badges = GlobalBadge.where(:semester => [nil, semester], :category => "Testing")
	    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

	  	# Return new badges received
	  	respond_to do |format|
	  		format.json { render :json => { :newtests => returntests, :badges => badgesviewmodel } }
    end
  end
end

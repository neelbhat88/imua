class TestingController < ApplicationController
	before_filter :authenticate_user!

	def index
		alltesting = current_user.user_testings.where('semester = ?', current_user.user_info.current_semester).order("date DESC")

	  	tests = []
	  	alltesting.each do | a |
	  		tests << TestingViewModel.new(a)
	  	end

	  	# Get all global exam to put into dropdown
    	globalexams = GlobalExam.select([:id, :name]).order("name")

    	badges = GlobalBadge.where(:semester => [nil, current_user.user_info.current_semester], :category => "Testing")
    	badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user)

	  	respond_to do |format|
	  		format.json { render :json => {:usertests => tests, :globalexams => globalexams, :badges => badgesviewmodel} }
	  		format.html { render :layout => false } # index.html.erb
	  	end
	end

	def saveTesting
	    ##################################################
		# ---------------- Tests ----------------------
	    ##################################################
	  	testsJson = JSON.parse(params[:tests])
	  	removeJson = JSON.parse(params[:toRemove])	  

	  	# Add or Edit
	  	testsJson.each do | c |  		
	  		if c["dbid"] == ""		       
		        current_user.user_testings.create(:global_exam_id =>c["global_exam_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
		        								  :score=>c["score"],
		        								  :semester=>current_user.user_info.current_semester,
		        								 )
	  		else
	  			toEdit = current_user.user_testings.find(c["dbid"].to_i)

	        	toEdit.update_attributes(:global_exam_id =>c["global_exam_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
		        								  :score=>c["score"]
	        									)
			  end
	  	end

	  	# Remove
	  	removeJson.each do | r |
	  		if r["dbid"] != ""
	  			current_user.user_testings.find(r["dbid"].to_i).destroy
	  		end
	  	end

	  	# Reload all
	  	alltests = current_user.user_testings.where('semester = ?', current_user.user_info.current_semester).order("date DESC")

	    returntests = []
	    alltests.each do | a |		
	    	returntests << TestingViewModel.new(a)
	    end

	    ##################################################
	    # ------------------ BADGES ----------------------
	    ##################################################   	    
	    badgeProcessor = BadgeProcessor.new(current_user)
	    badgeProcessor.CheckSemesterTesting()	    
	  		  	
	  	# Reload badges
	    badges = GlobalBadge.where(:semester => [nil, current_user.user_info.current_semester], :category => "Testing")
	    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, current_user)

	  	# Return new badges received
	  	respond_to do |format|
	  		format.json { render :json => { :newtests => returntests, :badges => badgesviewmodel } }
    end
  end
end

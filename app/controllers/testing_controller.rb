class TestingController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :json

	def index
	  	respond_to do |format|
	  		format.html { render :layout => false } # index.html.erb
	  	end
	end

	def init
		user = params[:user_id].to_i == 0 ? current_user : UserRepository.new().LoadUser(params[:user_id].to_i)
	    semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
	    isTeacher = params[:isTeacher]

	    # Load all user tests that correspond witht the GlobalExams
		alltesting = user.user_testings.where('semester = ?', semester).order("date DESC")
	  	tests = []
	  	alltesting.each do | a |
	  		tests << TestingViewModel.new(a)
	  	end

	  	# Get all global exam to put into dropdown
    	globalexams = GlobalExam.select([:id, :name]).order("name")		

    	badges = GlobalBadgeRepository.new().LoadAllBadges(semester,"Testing")    	
    	badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)
    	
		# Get PracticeTests
    	actMathTests = PracticeTestRepository.new().LoadTestsAsArray(user.id, "Math")
    	actReadingTests = PracticeTestRepository.new().LoadTestsAsArray(user.id, "Reading")
    	actEnglishTests = PracticeTestRepository.new().LoadTestsAsArray(user.id, "English")
    	actScienceTests = PracticeTestRepository.new().LoadTestsAsArray(user.id, "Science")
    
	  	respond_to do |format|
	  		format.json { render :json => 
	  								{
	  									:usertests => tests, 
	  									:actMathTests => actMathTests,
	  									:actReadingTests => actReadingTests,
	  									:actEnglishTests => actEnglishTests,
	  									:actScienceTests => actScienceTests,
	  									:globalexams => globalexams, 
	  									:badges => badgesviewmodel,
	  									:editable => isTeacher == 'true' || (semester == current_user.user_info.current_semester),
			                            :semesters => (1..user.user_info.current_semester).to_a,
			                        	:init_semester =>user.user_info.current_semester
	  								} 
	  					}
	  	end
	end

	def saveUserTest
		user = params[:userId].to_i == 0 ? current_user : UserRepository.new().LoadUser(params[:user_id].to_i)    	    	
    	testId = params[:testId].to_i
    	userTestId = params[:userTestId].to_i
    	score = params[:score].to_i
    	semester = user.user_info.current_semester # Just use user's current semester since no semester dropdown on practice test page

    	userTest = nil
    	if userTestId == 0 # User has not taken test
    		userTest = user.user_practice_tests.create(:global_practice_test_id=>testId, :semester=>semester, :score=>score)
    	else 
    		# Update users test
    		userTest = user.user_practice_tests.find(userTestId)

    		userTest.update_attributes(:score => score, :semester=>semester)
    	end

    	respond_to do |format|
	  		format.json { render :json => 
	  								{
	  									:userTest => userTest,
	  								}
	  					}
	  	end
	end

	def saveTesting
	    ##################################################
		# ---------------- Tests ----------------------
	    ##################################################
	    user = params[:user_id].to_i == 0 ? current_user : UserRepository.new().LoadUser(params[:user_id].to_i)
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
	    badges = GlobalBadgeRepository.new().LoadAllBadges(semester, "Testing")
	    badgesviewmodel = GlobalBadge.GetBadgesViewModel(badges, user, semester)

	  	# Return new badges received
	  	respond_to do |format|
	  		format.json { render :json => { :newtests => returntests, :badges => badgesviewmodel } }
    	end
  	end
end

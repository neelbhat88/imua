class SuperAdminController < ApplicationController
	before_filter :authenticate_user!
  	before_filter :admin_only
	
	def index
		actMathTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Math")
    	actReadingTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Reading")
    	actEnglishTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "English")
    	actScienceTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Science")

    	@dataModel = {
    		:actMathTests => actMathTests,
    		:actReadingTests => actReadingTests
    	}

    	respond_to do |format|
	      format.html { render :layout=>true } # index.html.erb	
	  	end
	end
end

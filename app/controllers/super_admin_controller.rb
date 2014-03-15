class SuperAdminController < ApplicationController
	before_filter :authenticate_user!
  	before_filter :admin_only
	
    respond_to :json

	def index
		actMathTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Math")
    	actReadingTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Reading")
    	actEnglishTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "English")
    	actScienceTests = PracticeTestRepository.new().LoadTestsAsArray(current_user.id, "Science")

        testSubjects = TestPrepRepository.new().LoadAllSubjects()

    	@dataModel = {
    		:actMathTests => actMathTests,
    		:actReadingTests => actReadingTests,
            :TestSubjects => testSubjects
    	}

    	respond_to do |format|
	      format.html { render :layout=>true } # index.html.erb	
	  	end
	end

    def add_subject
        subjectName = params[:name]

        newSubject = TestPrepRepository.new().CreateSubject(subjectName)

        respond_with newSubject, location: super_admin_dashboard_url
    end

    def add_category
        subjectName = params[:subjectName]
        categoryName = params[:name]
        categoryLevel = params[:level].to_i

        newCategory = TestPrepRepository.new().CreateCategory(subjectName, categoryName, categoryLevel)

        respond_with newCategory, location: super_admin_dashboard_url 
    end

    def add_sub_category
        categoryName = params[:categoryName]
        subCategoryName = params[:name]
        subCategoryDesc = params[:description]  
        subCategoryLevel = params[:level].to_i

        newSubCategory = TestPrepRepository.new().CreateSubCategory(categoryName, subCategoryName, subCategoryDesc, subCategoryLevel)

        respond_with newSubCategory, location: super_admin_dashboard_url
    end
end

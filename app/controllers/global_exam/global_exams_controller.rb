class GlobalExam::GlobalExamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only

  # GET /global_exams
  # GET /global_exams.json
  def index
    @global_exams = GlobalExam.order("exam_type, id")
    @global_practice_tests = GlobalPracticeTest.order("semester, name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => 
                            {
                              :globalexams => @global_exams, 
                              :globalpracticetests => @global_practice_tests 
                            }
                  }
    end
  end
  
  def newexam
    @global_exam = GlobalExam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_exam }
    end
  end

  def newpracticetest
    @practice_test = GlobalPracticeTest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_practice_test }
    end
  end

    # POST /global_exam/other
  # POST /global_exam/other.json
  def createexam
    @global_exam = GlobalExam.new(params[:global_exam])

    respond_to do |format|
      if @global_exam.save
        if params[:save_add_another]
          format.html { redirect_to global_exam_newexam_url, notice: 'Global exam was successfully created.' }
        else
          format.html { redirect_to global_exam_root_url, notice: 'Global exam was successfully created.' }
        end      
      else
        format.html { render action: "new" }
        format.json { render json: @global_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /global_exam/practice
  # POST /global_exam/practice.json
  def createpracticetest
    @practice_test = GlobalPracticeTest.new(params[:global_practice_test])

    respond_to do |format|
      if @practice_test.save
        if params[:save_add_another]
          format.html { redirect_to global_exam_newpracticetest_url, notice: 'Practice test was successfully created.' }
        else
          format.html { redirect_to global_exam_root_url, notice: 'Practice test was successfully created.' }
        end      
      else
        format.html { render action: "new" }
        format.json { render json: @practice_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /global_exams/other/1/edit
  def editexam
    @global_exam = GlobalExam.find(params[:id])
  end

  def editpracticetest
    @practice_test = GlobalPracticeTest.find(params[:id])
  end

  # PUT /global_exam/other/1
  # PUT /global_exam/other/1.json
  def updateexam
    @global_exam = GlobalExam.find(params[:id])

    respond_to do |format|
      if @global_exam.update_attributes(params[:global_exam])
        format.html { redirect_to global_exam_root_url, notice: 'Global exam was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @global_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /global_exam/practice/1
  # PUT /global_exam/practice/1.json
  def updatepracticetest
    @practice_test = GlobalPracticeTest.find(params[:id])

    respond_to do |format|
      if @practice_test.update_attributes(params[:global_practice_test])
        format.html { redirect_to global_exam_root_url, notice: 'Practice test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @practice_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /global_exams/other/1
  def destroyexam
    @global_exam = GlobalExam.find(params[:id])
    @global_exam.destroy

    respond_to do |format|
      format.html { redirect_to global_exam_root_url }
      format.json { head :no_content }
    end
  end

  # DELETE /global_exams/practice/1
  def destroypracticetest
    @practice_test = GlobalPracticeTest.find(params[:id])
    @practice_test.destroy

    respond_to do |format|
      format.html { redirect_to global_exam_root_url }
      format.json { head :no_content }
    end
  end
end

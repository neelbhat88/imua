class GlobalExamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only

  # GET /global_exams
  # GET /global_exams.json
  def index
    @global_exams = GlobalExam.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @global_exams }
    end
  end

  # GET /global_exams/1
  # GET /global_exams/1.json
  def show
    @global_exam = GlobalExam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @global_exam }
    end
  end

  # GET /global_exams/new
  # GET /global_exams/new.json
  def new
    @global_exam = GlobalExam.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_exam }
    end
  end

  # GET /global_exams/1/edit
  def edit
    @global_exam = GlobalExam.find(params[:id])
  end

  # POST /global_exams
  # POST /global_exams.json
  def create
    @global_exam = GlobalExam.new(params[:global_exam])

    respond_to do |format|
      if @global_exam.save
        if params[:save_add_another]
          format.html { redirect_to new_global_exam_url, notice: 'Global exam was successfully created.' }
        else
          format.html { redirect_to global_exams_url, notice: 'Global exam was successfully created.' }
        end      
      else
        format.html { render action: "new" }
        format.json { render json: @global_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /global_exams/1
  # PUT /global_exams/1.json
  def update
    @global_exam = GlobalExam.find(params[:id])

    respond_to do |format|
      if @global_exam.update_attributes(params[:global_exam])
        format.html { redirect_to global_exams_url, notice: 'Global exam was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @global_exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /global_exams/1
  # DELETE /global_exams/1.json
  def destroy
    @global_exam = GlobalExam.find(params[:id])
    @global_exam.destroy

    respond_to do |format|
      format.html { redirect_to global_exams_url }
      format.json { head :no_content }
    end
  end
end

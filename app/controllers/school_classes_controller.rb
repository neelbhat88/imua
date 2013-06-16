class SchoolClassesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only  

  # GET /school_classes
  # GET /school_classes.json
  def index
    @school_classes = SchoolClass.where('school_id = ?', current_user.user_info.school_id).order("name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @school_classes }
    end
  end

  # GET /school_classes/1
  # GET /school_classes/1.json
  def show
    @school_class = SchoolClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_class }
    end
  end

  # GET /school_classes/new
  # GET /school_classes/new.json
  def new
    @school_class = SchoolClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school_class }
    end
  end

  # GET /school_classes/1/edit
  def edit
    @school_class = SchoolClass.find(params[:id])
  end

  # POST /school_classes
  # POST /school_classes.json
  def create
    name = params[:school_class][:name]
    level = params[:school_class][:level]
    school_id = current_user.user_info.school_id

    @school_class = SchoolClass.new(:name => name, :level => level, :school_id => school_id)

    respond_to do |format|
      if @school_class.save        
        if params[:save_add_another]
          format.html {redirect_to new_school_class_url, notice: 'Class was successfully created.' }
        else
          format.html {redirect_to school_classes_url, notice: 'Class was successfully created.'}
        end
        #format.html { redirect_to @school_class, notice: 'Class was successfully created.' }
        #format.json { render json: @school_class, status: :created, location: @school_class }
      else
        format.html { render action: "new" }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /school_classes/1
  # PUT /school_classes/1.json
  def update
    @school_class = SchoolClass.find(params[:id])

    respond_to do |format|
      if @school_class.update_attributes(params[:school_class])
        format.html { redirect_to school_classes_url, notice: 'Class was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_classes/1
  # DELETE /school_classes/1.json
  def destroy
    @school_class = SchoolClass.find(params[:id])
    @school_class.destroy

    respond_to do |format|
      format.html { redirect_to school_classes_url }
      format.json { head :no_content }
    end
  end
end

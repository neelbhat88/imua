class SchoolActivitiesController < ApplicationController
  # GET /school_activities
  # GET /school_activities.json
  def index
    @school_activities = SchoolActivity.where("school_id = ?", current_user.user_info.school_id).order("name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @school_activities }
    end
  end

  # GET /school_activities/1
  # GET /school_activities/1.json
  def show
    @school_activity = SchoolActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_activity }
    end
  end

  # GET /school_activities/new
  # GET /school_activities/new.json
  def new
    @school_activity = SchoolActivity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school_activity }
    end
  end

  # GET /school_activities/1/edit
  def edit
    @school_activity = SchoolActivity.find(params[:id])
  end

  # POST /school_activities
  # POST /school_activities.json
  def create
    name = params[:school_activity][:name]
    school_id = current_user.user_info.school_id

    @school_activity = SchoolActivity.new(:name => name, :school_id => school_id)    

    respond_to do |format|
      if @school_activity.save
        if params[:save_add_another]
          format.html { redirect_to new_school_activity_url, notice: 'School activity was successfully created.' }
        else
          format.html { redirect_to school_activities_url, notice: 'School activity was successfully created.' }
        end

        #format.html { redirect_to @school_activity, notice: 'School activity was successfully created.' }
        #format.json { render json: @school_activity, status: :created, location: @school_activity }
      else
        format.html { render action: "new" }
        format.json { render json: @school_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /school_activities/1
  # PUT /school_activities/1.json
  def update
    @school_activity = SchoolActivity.find(params[:id])
    @school_activity.school_id = curr_user.user_info.school_id

    respond_to do |format|
      if @school_activity.update_attributes(params[:school_activity])
        format.html { redirect_to @school_activity, notice: 'School activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @school_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_activities/1
  # DELETE /school_activities/1.json
  def destroy
    @school_activity = SchoolActivity.find(params[:id])
    @school_activity.destroy

    respond_to do |format|
      format.html { redirect_to school_activities_url }
      format.json { head :no_content }
    end
  end
end

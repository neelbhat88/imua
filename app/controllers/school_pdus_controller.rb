class SchoolPdusController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  
  # GET /school_pdus
  # GET /school_pdus.json
  def index
    @school_pdus = SchoolPdu.where("school_id = ?", current_user.user_info.school_id).order("name")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @school_pdus }
    end
  end

  # GET /school_pdus/1
  # GET /school_pdus/1.json
  def show
    @school_pdu = SchoolPdu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_pdu }
    end
  end

  # GET /school_pdus/new
  # GET /school_pdus/new.json
  def new
    @school_pdu = SchoolPdu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school_pdu }
    end
  end

  # GET /school_pdus/1/edit
  def edit
    @school_pdu = SchoolPdu.find(params[:id])
  end

  # POST /school_pdus
  # POST /school_pdus.json
  def create
    name = params[:school_pdu][:name]
    school_id = current_user.user_info.school_id
    
    @school_pdu = SchoolPdu.new(:name => name, :school_id => school_id)

    respond_to do |format|
      if @school_pdu.save
        if params[:save_add_another]
          format.html { redirect_to new_school_pdu_url, notice: 'School PDU was successfully created.' }
        else
          format.html { redirect_to school_pdus_url, notice: 'School PDU was successfully created.' }
        end

        #format.html { redirect_to @school_activity, notice: 'School activity was successfully created.' }
        #format.json { render json: @school_activity, status: :created, location: @school_activity }
      else
        format.html { render action: "new" }
        format.json { render json: @school_pdu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /school_pdus/1
  # PUT /school_pdus/1.json
  def update
    @school_pdu = SchoolPdu.find(params[:id])

    respond_to do |format|
      if @school_pdu.update_attributes(params[:school_pdu])
        format.html { redirect_to school_pdus_url, notice: 'School pdu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @school_pdu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_pdus/1
  # DELETE /school_pdus/1.json
  def destroy
    @school_pdu = SchoolPdu.find(params[:id])
    @school_pdu.destroy

    respond_to do |format|
      format.html { redirect_to school_pdus_url }
      format.json { head :no_content }
    end
  end
end

class PdusController < ApplicationController
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

		allpdus = user.user_pdus.where('semester = ?', semester).order("date DESC")

	  	pdus = []
	  	allpdus.each do | a |
	  		pdus << PduViewModel.new(a)
	  	end

	  	# Get all global pdu to put into dropdown
    	globalpdus = SchoolPdu.where('school_id = ?', user.user_info.school_id).select([:id, :name]).order("name")

    	badgesviewmodel =  BadgeFactory.new.GetBadges(:user => user, :semester => semester, :category => "PDU")
                                             .map{|b| BadgeViewModel.new(b) }

	  	respond_to do |format|
	  		format.json { render :json => 
	  								{
	  									:userpdus => pdus, 
	  									:globalpdus => globalpdus,
	  									:badges => badgesviewmodel,
	  									:editable => isTeacher == 'true' || (semester == current_user.user_info.current_semester),
			                            :semesters => (1..user.user_info.current_semester).to_a,
			                        	:init_semester =>user.user_info.current_semester
	  								} 
	  					}
	  	end
	end

	def savePdus
	    ##################################################
		# ---------------- PDUs ----------------------
	    ##################################################
	    user = params[:user_id].to_i == 0 ? current_user : User.find(params[:user_id].to_i)
    	semester = params[:semester].to_i == 0 ? user.user_info.current_semester : params[:semester].to_i
	  	pdusJson = JSON.parse(params[:pdus])
	  	removeJson = JSON.parse(params[:toRemove])
	  	
	  	# Add or Edit
	  	pdusJson.each do | c |  		
	  		if c["dbid"] == ""
		        user.user_pdus.create(:school_pdu_id =>c["school_pdu_id"],
    								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
    								  :hours=>c["hours"],
    								  :semester=>semester,
    								 )
	  		else
	  			toEdit = user.user_pdus.find(c["dbid"].to_i)
	        	toEdit.update_attributes(:school_pdu_id =>c["school_pdu_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
		        								  :hours=>c["hours"]
	        									)
			  end
	  	end

	  	# Remove
	  	removeJson.each do | r |
	  		if r["dbid"] != ""
	  			user.user_pdus.find(r["dbid"].to_i).destroy
	  		end
	  	end

	  	# Reload all
	  	allpdus = user.user_pdus.where('semester = ?', semester).order("date DESC")

	    returnpdus = []
	    allpdus.each do | a |		
	    	returnpdus << PduViewModel.new(a)
	    end

	    ##################################################
	    # ------------------ BADGES ----------------------
	    ##################################################   	    
	    BadgeProcessor.new.CheckSemesterPdus(user, semester)
	  		  	
	  	# Reload badges
	    badgesviewmodel =  BadgeFactory.new.GetBadges(:user => user, :semester => semester, :category => "PDU")
                                             .map{|b| BadgeViewModel.new(b) }

	  	# Return new badges received
	  	respond_to do |format|
	  		format.json { render :json => { :newpdus => returnpdus, :badges => badgesviewmodel } }
    end
  end
end

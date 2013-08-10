class PdusController < ApplicationController
	def index
		allpdus = current_user.user_pdus.where('semester = ?', current_user.user_info.current_semester).order("date DESC")

	  	pdus = []
	  	allpdus.each do | a |
	  		pdus << PduViewModel.new(a)
	  	end

	  	# Get all global pdu to put into dropdown
    	globalpdus = SchoolPdu.where('school_id = ?', current_user.user_info.school_id).select([:id, :name]).order("name")

	  	respond_to do |format|
	  		format.json { render :json => {:userpdus => pdus, :globalpdus => globalpdus} }
	  		format.html { render :layout => false } # index.html.erb
	  	end
	end

	def savePdus
	    ##################################################
		# ---------------- PDUs ----------------------
	    ##################################################
	  	pdusJson = JSON.parse(params[:pdus])
	  	removeJson = JSON.parse(params[:toRemove])

	  	logger.debug "DEBUG: Pdus - #{pdusJson}"
	  	logger.debug "DEBUG: To Remove - #{removeJson}"  

	  	# Add or Edit
	  	pdusJson.each do | c |  		
	  		if c["dbid"] == ""  			
		        logger.debug "DEBUG: New UserPdu SchoolPduId = #{c["school_pdu_id"]}, date = #{c["date"]} hours = #{c["hours"]} }"
		        
		        current_user.user_pdus.create(:school_pdu_id =>c["school_pdu_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date, 
		        								  :hours=>c["hours"],
		        								  :semester=>current_user.user_info.current_semester,
		        								 )
	  		else
	  			toEdit = current_user.user_pdus.find(c["dbid"].to_i)
	  			logger.debug "DEBUG: Existing UserPdu id = #{c["dbid"]} date = #{c["date"]}"

	        	toEdit.update_attributes(:school_pdu_id =>c["school_pdu_id"],
		        								  :date=>Date.strptime(c["date"], "%m/%d/%Y").to_date,
		        								  :hours=>c["hours"]
	        									)
			  end
	  	end

	  	# Remove
	  	removeJson.each do | r |
	  		if r["dbid"] != ""
	  			logger.debug "DEBUG: Removing pdu with id = #{r["dbid"]}"
	  			current_user.user_pdus.find(r["dbid"].to_i).destroy
	  		end
	  	end

	  	# Reload all
	  	allpdus = current_user.user_pdus.where('semester = ?', current_user.user_info.current_semester).order("date DESC")

	    returnpdus = []
	    allpdus.each do | a |		
	    	returnpdus << PduViewModel.new(a)
	    end

	    ##################################################
	    # ------------------ BADGES ----------------------
	    ##################################################   	    
	    #badgeProcessor = BadgeProcessor.new(current_user)
	    #newBadgeCount = badgeProcessor.CheckSemesterPdus()
	  	
	  	#logger.debug "DEBUG: Earned #{@newbadgecount} new badges."

	  	# Return new badges received
	  	respond_to do |format|
	  		format.json { render :json => { :newpdus => returnpdus} }
    end
  end
end

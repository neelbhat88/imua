class MyBadgesController < ApplicationController
	before_filter :authenticate_user!

	def index
		# Grid Badges
		alluserbadges = UserBadge.all
		gridbadges = []
		alluserbadges.each do |ub|
			gridbadges << GridBadgeViewModel.new(ub)
		end

		# Grid Cells
		rows = params[:rows].to_i
		cols = params[:cols].to_i
		cellnum = 0

		gridrows = []

		#gridrows.each_with_index do | r, index |
		#(rows.downto(0)).each do | r |		
		(0...rows).each do |r|
			gridcells = []
			(0...cols).each do | i |
				#logger.debug("DEBUG: Row: #{r}")
			 	gridcells << GridCellViewModel.new(r, cellnum, i+1)
			 	#logger.debug("DEBUG: #{gridcells}")
			 	cellnum += 1
			 end

			 gridrows << {"gridcells" => gridcells}
			 #logger.debug("DEBUG: #{gridrows}")
		end

		respond_to do |format|
	  		format.json { render :json => {:gridbadges => gridbadges, :gridrows => gridrows} }
	  		format.html # index.html.erb
  		end
	end

	def updateGrid		
		if params[:id] == ""
			raise "Error: BadgeId in method updageGrid cannot be null"
		end

		id = params[:id].to_i		
		gridcellnum = params[:gridcellnum] == "" ? nil : params[:gridcellnum].to_i	
		rownum = params[:rownum] == "" ? nil : params[:rownum].to_i

		logger.debug{"DEBUG: BadgeId: #{id}, GridCellNum: #{gridcellnum}, RowNum: #{rownum}"}

		UserBadge.find(id).update_attributes(:gridcellnum => gridcellnum, :rownum => rownum)
		logger.debug("DEBUG: Updated badgeid #{id} to #{gridcellnum}")	
	end
end

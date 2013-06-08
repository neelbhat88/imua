class BadgeProcessor
	attr_accessor :curr_user
	
	def initialize(user)
		@badgefactory = BadgeFactory.new(user)
		@curr_user = user
	end

	def CheckSemesterAcademics
		allBadges = @badgefactory.GetAcademicsBadges(@curr_user.user_info.current_semester)		

	  	# Call compare and pass in totalGPA
	  	newbadgecount = 0
	  	allBadges.each do |b|
	  		badgeEarned = b.Compare()
	  		userHasBadge = (@curr_user.user_badges.find_by_global_badge_id(b.id) != nil)
	  		
	  		# If badge earned and user does not have badge
	  		if badgeEarned == true && userHasBadge == false
	  			newbadgecount += 1

	  			# Save earned badge to db
	  			@curr_user.user_badges.create(:global_badge_id => b.id)
	  		# If badge not earned and user has badge
	  		elsif badgeEarned == false && userHasBadge == true
	  			removedBadge = @curr_user.user_badges.find_by_global_badge_id(b.id)

	  			# Remove earned badge
	  			@curr_user.user_badges.find_by_global_badge_id(b.id).destroy()
	  			Rails.logger.debug("DEBUG: BadgeEarned = false and UserHasBadge = true. UserBadge with GlobalBadgeId: #{b.id} removed.")

	  			# Check if minimum requirements met
	  			# if AllMinimumRequirementsMet() == true
	  			# 	# Move badges above badge down
	  			# 	Rails.logger.debug("DEBUG: Removing badge with RowNum: #{removedBadge.rownum}, GridCellNum: #{removedBadge.gridcellnum}")
	  			# 	if (removedBadge.gridcellnum != nil)
	  			# 		MoveBadgesDownOnGrid(removedBadge)
	  			# 	end
	  			# else
	  			# 	# Remove all UserBadges from Grid
	  			# 	Rails.logger.debug("DEBUG: Removing all badges from grid")
	  			# 	@curr_user.user_badges.update_all(:gridcellnum => nil)
	  			# end	
	  		end
	  	end

	  	return newbadgecount
	end

	private
		# def AllMinimumRequirementsMet
		# 	current_min_reqs = GlobalBadge.where('semester = ? and isminrequirement = true', @curr_user.user_info.current_semester)

		# 	current_min_reqs.each do |r|
		# 		if @curr_user.user_badges.find_by_global_badge_id(r.id) == nil
		# 			return false
		# 		end
		# 	end

		# 	return true
		# end

		# def MoveBadgesDownOnGrid(removedBadge)
		# 	rowNum = removedBadge.rownum
		# 	currBadge = removedBadge

		# 	#Stacking two on top doesn't work, check the logic here!!!!
		# 	# TODO: Fix this later since no more Grid

		# 	while rowNum > 0 do
		# 		# Get badge above current badge
		# 		badgeAbove = @curr_user.user_badges.where('rownum = ?', rowNum - 1)[0]
				
		# 		return if (badgeAbove.nil?)					

		# 		Rails.logger.debug "DEBUG: Updating badge at rowNum #{badgeAbove.rownum} and gridcellnum #{badgeAbove.gridcellnum} to #{rowNum} and #{currBadge.gridcellnum}"
		# 		badgeAbove.update_attributes(:rownum => rowNum, :gridcellnum => currBadge.gridcellnum)
				
		# 		rowNum -= 1
		# 		currBadge = badgeAbove
		# 	end
		# 	# return if rowNum < 0

		# 	# # Get badge above current badge
		# 	# badgeAbove = @curr_user.user_badges.where('rownum = ?', rowNum - 1)[0]
			
		# 	# if (badgeAbove.nil?)
		# 	# 	return

		# 	# Rails.logger.debug "DEBUG: Updating badge at rowNum #{badgeAbove.rownum} and gridcellnum #{badgeAbove.gridcellnum} to #{rowNum} and #{gridcellnum}"
		# 	# badgeAbove.update_attributes(:rownum => rowNum, :gridcellnum => gridCellNum)

		# 	# MoveBadgesDownOnGrid(rowNum - 1, badgeAbove.gridCellNum)
		# end
end
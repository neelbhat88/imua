class StatsController < ApplicationController
	before_filter :authenticate_user!
	
	def index
	end

	def init
		semester = current_user.user_info.current_semester		

		# Get total badges earned
		totalBadgesEarned = GlobalBadge.GetNumBadgesEarned(current_user)

		# Get total badge value
		totalBadgesValue = 0
		(0..semester).each do |s|
			if current_user.user_info.MetAllMinRequirements(s)				
				# includes loads all the data into memory, so accessing the associated data doesn't make a DB call
				badges = current_user.user_badges.includes(:global_badge).where('user_badges.semester = ?', s)
				badges.each do |b|
					totalBadgesValue += b.global_badge.badge_value
				end
			end
		end

		# Total deduction value and deductions
		totalDeductionValue = current_user.user_deductions.sum(:deduction_value)

		deductionsViewModel = []
		current_user.user_deductions.order("deduction_value DESC").each do | d |
			deductionsViewModel << UserDeductionViewModel.new(d)
		end


		# Get total possible badges
		allGlobalBadges = GlobalBadge.all
		totalBadgesPossible = (allGlobalBadges.select{|badge| badge.semester == nil}.length * 8) + (allGlobalBadges.select{|badge| badge.semester != nil}.length)

		# Cumulative GPA
		cumulative_gpa = 0.00
		if current_user.user_semester_gpas.length > 0
			cumulative_gpa = '%.2f' % current_user.user_semester_gpas.average('gpa')
		end

		# Total Extracurriculars
		totalactivities = current_user.user_activities.length

		# Total Service Hours
		totalservice = current_user.user_services.sum('hours')

		# Total PDUs
		totalpdus = current_user.user_pdus.length

		respond_to do |format|
			format.json { render :json => {:totalbadgesearned => totalBadgesEarned,
										   :totalbadgesvalue => totalBadgesValue,
										   :totalbadgespossible => totalBadgesPossible,
										   :cumulativegpa => cumulative_gpa,
										   :totalactivities => totalactivities,
										   :totalservice => totalservice,
										   :totalpdus => totalpdus,
										   :totaldeductionvalue => totalDeductionValue,
										   :totaldeductionslist => deductionsViewModel } }
		end
	end
end

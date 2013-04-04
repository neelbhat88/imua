class GlobalBadgesController < ApplicationController
	def index
		@allbadges = GlobalBadge.all
	end

	def new
		@badge = GlobalBadge.new
	end
end

class ActivityViewModel
	attr_accessor :name, :leadershipHeld, :leadershipTitle, 
					:dbid, :school_activity_id, :description

	def initialize(useractivity)		
		@name = useractivity.school_activity.name
		@leadershipHeld = useractivity.leadership_held
		@leadershipTitle = useractivity.leadership_title
		@school_activity_id = useractivity.school_activity_id
		@description = SetDescription(useractivity.description)
		
		@dbid = useractivity.id
	end

	def SetDescription(description)
		descriptionArray = []

		if (description != nil)
			sentenceArray = description.split("|")

			sentenceArray.each do | s |
				descriptionArray << SentenceViewModel.new(s)
			end
		end

		return descriptionArray
	end
end
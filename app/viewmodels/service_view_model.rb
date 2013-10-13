class ServiceViewModel
	attr_accessor :name, :date, :hours, :dbid

	def initialize(service)		
		@name = service.name		
		@date = service.date.strftime("%m/%d/%Y")
		@hours = service.hours

		@dbid = service.id
	end
end
class PduViewModel
	attr_accessor :name, :date, :hours, :dbid

	def initialize(pdu)		
		@name = pdu.school_pdu.name		
		@date = pdu.date.strftime("%m/%d/%Y")
		@hours = pdu.hours

		@school_pdu_id = pdu.school_pdu_id
		@dbid = pdu.id
	end
end
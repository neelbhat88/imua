class UserDeductionViewModel
	attr_accessor :details, :value

	def initialize(deduction)		
		@details = deduction.deduction_details		
		@value = deduction.deduction_value
	end
end
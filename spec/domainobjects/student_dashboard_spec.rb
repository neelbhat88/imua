require 'spec_helper'

describe StudentRepository do
	describe "LoadStudentDashboard return value" do
		@semester = 1
		let(:user) do
			mock_model User,:id => 1,
							:first_name => "Neel",
							:last_name => "Bhat"							 
		end

		before :each do
			@student_repo = StudentRepository.new
			@studentDashboard = @student_repo.LoadStudentDashboard(user, @semester)
		end

		it "has student information" do
			@studentDashboard.first_name.should eql user.first_name
			@studentDashboard.last_name.should eql user.last_name
			@studentDashboard.user_id.should eql user.id
		end	
	end
end
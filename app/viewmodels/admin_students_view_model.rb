class AdminStudentsViewModel
	attr_accessor :class_of

	def initialize(student, urlHelper = UrlHelper.new)
		@id = student.id
		@email = student.email
		@phone = student.user_info.phone
		@name = student.first_name + " " + student.last_name
		@current_semester = student.user_info.current_semester		
		@class_of = student.user_info.classof		
		@last_login_date = student.current_sign_in_at == nil ? 'Never logged in.' : student.current_sign_in_at.in_time_zone("Hawaii").to_formatted_s(:long) # TODO: Remove the hardcoded Hawaii timezone
		@login_count = student.sign_in_count

		@picture_url = urlHelper.GetFullDefaultAvatarUrl(student.user_info.avatar.url(:original).to_s)
		@is_default_image = urlHelper.IsDefaultAvatarUrl(student.user_info.avatar.url(:original).to_s)
	end	

	def class_of
		return @class_of
	end
end
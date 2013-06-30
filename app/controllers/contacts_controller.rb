class ContactsController < ApplicationController
	layout "static_pages"

	def index
		@title = "Waianae Coast Scholarship Fund | Contact Us"
	end

  def create
		@contact = Contact.new(params[:contact])
		@contact.request = request
		if @contact.deliver
			flash[:notice] = "Thank you for your message!"
		else
			flash[:error] = "Your message could not be delivered."
		end
		redirect_to contact_path
  end

end

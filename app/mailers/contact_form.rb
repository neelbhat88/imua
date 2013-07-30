class ContactForm < ActionMailer::Base
  default from: "info@wcsfscholars.org"

  def contact_email(contact)
    @name = contact.name
    @email  = contact.email
    @message = contact.message
    mail(:to => "ryan@launchpadlab.com", :subject => "Contact Form: #{contact.name}")
  end
end

class ContactForm < ActionMailer::Base
  default from: "wcsf.directors@gmail.com"

  def contact_email(contact)
    @name = contact.name
    @email  = contact.email
    @message = contact.message
    mail(:to => "wcsf.directors@gmail.com", :subject => "Contact Form: #{contact.name}")
  end
end

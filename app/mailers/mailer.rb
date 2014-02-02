class Mailer < ActionMailer::Base
  default from: "site@websiteone.com"

  def contact_form(contact_form)
    @contact_form = contact_form
    from = contact_form[:email]
    mail(from: from, to: 'wso.av.test@gmail.com', subject: 'WebsiteOne Contact Form')
  end
end

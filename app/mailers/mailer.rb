class Mailer < ActionMailer::Base
  default from: 'site@websiteone.com'

  def contact_form(contact_form)
    @contact_form = contact_form
    from = contact_form[:email]
    mail(reply_to: from, to: 'wso.av.test@gmail.com', subject: 'WebsiteOne Contact Form')
  end

  def contact_form_confirmation(contact_form)
    @contact_form = contact_form
    to = contact_form[:email]
    mail(to: to, subject: 'WebsiteOne Contact Form')
  end
end

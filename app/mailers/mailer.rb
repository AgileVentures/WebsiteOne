class Mailer < ActionMailer::Base
  default from: 'info@agileventures.org', reply_to: 'info@agileventures.org'

  def contact_form(contact_form)
    @contact_form = contact_form
    from = contact_form[:email]
    mail(reply_to: from, to: 'info@agileventures.org', subject: 'WebsiteOne Contact Form')
  end

  def contact_form_confirmation(contact_form)
    @contact_form = contact_form
    to = contact_form[:email]
    mail(to: to, subject: 'WebsiteOne Contact Form')
  end

  def send_welcome_message(user)
    # Bryan: Disabled while the email limit is over
    @user = user
    mail(to: user.email, subject: 'Welcome to AgileVentures.org')
  end

  def hire_me_form(user, hire_me_form)
    @user = user
    @form = hire_me_form
    subject = ['message from', @form[:name]].join(' ')
    mail(to: @user.email, reply_to: @form[:email], from: @form[:email], subject: subject)
  end
end

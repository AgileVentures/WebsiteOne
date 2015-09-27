class Mailer < ActionMailer::Base
  default from: 'info@agileventures.org', reply_to: 'info@agileventures.org', cc: 'support@agileventures.org'

  def send_welcome_message(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to AgileVentures.org')
  end

  def hire_me_form(user, hire_me_form)
    @user = user
    @form = hire_me_form
    subject = ['message from', @form[:name]].join(' ')
    mail(to: @user.email, reply_to: @form[:email], from: @form[:email], subject: subject)
  end

  def send_newsletter(user, newsletter)
    @user = user
    @newsletter = newsletter
    mail(to: user.email, subject: newsletter.subject)
  end
end

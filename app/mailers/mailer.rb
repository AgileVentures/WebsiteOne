class Mailer < ActionMailer::Base
  default from: 'info@agileventures.org', reply_to: 'info@agileventures.org', cc: 'support@agileventures.org'

  def send_premium_payment_complete(email)
    mail(to: email, subject: 'Welcome to AgileVentures Premium')
  end

  def send_sponsor_premium_payment_complete(email, sponsor_email)
    user = User.find_by(email: sponsor_email)
    @sponsor = user.nil? ? sponsor_email : user.full_name
    mail(to: email, subject: 'You\'ve been sponsored for AgileVentures Premium Membership')
  end

  def send_premium_f2f_payment_complete(email)
    mail(to: email, subject: 'Welcome to AgileVentures Premium F2F')
  end

  def send_premium_mob_payment_complete(email)
    mail(to: email, subject: 'Welcome to AgileVentures Premium Mob')
  end

  def send_premium_plus_payment_complete(email)
    mail(to: email, subject: 'Welcome to AgileVentures Premium Plus')
  end

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

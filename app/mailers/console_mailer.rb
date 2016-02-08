class ConsoleMailer < ActionMailer::Base

  default from: 'info@agileventures.org', reply_to: 'info@agileventures.org', cc: 'support@agileventures.org'

  def newsletter(user, opts)
    @user = user
    @heading = opts.fetch(:heading)
    @content = opts.fetch(:content)
    @subject = opts[:subject] || @heading

    mail(to: user.email, subject: @subject)
  end

end

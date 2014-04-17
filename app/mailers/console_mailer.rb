class ConsoleMailer < ActionMailer::Base
  add_template_helper(UsersHelper)

  default from: 'info@agileventures.org', reply_to: 'info@agileventures.org'

  def newsletter(user, opts)
    @user = user
    @heading = opts.fetch(:heading)
    @content = opts.fetch(:content)
    @subject = opts[:subject] || @heading

    mail(to: user.email, subject: @subject)
  end

end

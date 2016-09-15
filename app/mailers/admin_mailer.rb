class AdminMailer < ApplicationMailer
  default from: "bot@agileventures.org"

  def failed_to_invite_user_to_slack(email, error)
    @error = error
    @email = email
    mail(subject: "Slack invite failed for user with email '#{email}'.",
         to: "support@agileventures.org")
  end

end

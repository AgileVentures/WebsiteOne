class AdminMailer < ApplicationMailer
  default from: "bot@agileventures.org"

  def failed_to_invite_user_to_slack(email, error, slack_error_message)
    @error = error
    @email = email
    @slack_error_message = slack_error_message
    mail(subject: "Slack invite failed for user with email '#{email}'.",
         to: "support@agileventures.org")
  end

end

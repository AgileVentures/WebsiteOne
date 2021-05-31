# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default from: 'bot@agileventures.org'

  def failed_to_invite_user_to_slack(email, error, slack_error_message)
    @error_message = error.message if error
    @backtrace_output = backtrace_output
    @email = email
    @slack_error_message = slack_error_message
    mail(subject: "Slack invite failed for user with email '#{email}'.",
         to: 'support@agileventures.org')
  end

  private

  def backtrace_output
    backtrace = @error.backtrace if @error
    backtrace ? backtrace.join("\n\t") : ''
  end
end

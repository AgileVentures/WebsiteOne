class SlackInviteJob
  include SuckerPunch::Job

  SLACK_INVITE_URL = 'https://agileventures.slack.com/api/users.admin.invite'

  def perform(email)
    uri = URI.parse SLACK_INVITE_URL
    response = Net::HTTP.post_form(uri, {
        email: email,
        channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
        token: Slack::AUTH_TOKEN
    })
    error = nil
    json_response = JSON.parse response.body
    slack_error_message = json_response['error']
    json_response
  rescue => e
    error = e
  ensure
    unless json_response.present? and json_response['ok']
      AdminMailer.failed_to_invite_user_to_slack(email, error, slack_error_message).deliver_later
    end
  end
end

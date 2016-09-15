class SlackInviteJob
  include SuckerPunch::Job

  def perform(email)
    uri = URI.parse 'https://agileventures.slack.com/api/users.admin.invite'
    response = Net::HTTP.post_form(uri, {
        email: email,
        channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
        token: Slack::AUTH_TOKEN
    })
    error = nil
    json_response = JSON.parse response.body
  rescue => e
    error = e
  ensure
    unless json_response.present? and json_response['ok']
      AdminMailer.failed_to_invite_user_to_slack(email, error)
    end
  end
end

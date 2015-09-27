class SlackInviteJob
  include SuckerPunch::Job

  def perform(email)
    uri = URI.parse 'https://agileventures.slack.com/api/users.admin.invite'
    response = Net::HTTP.post_form(uri, {
      email: email,
      channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
      token: Slack::AUTH_TOKEN
    })
    JSON.parse response.body
  end
end

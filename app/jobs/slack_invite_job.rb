class SlackInviteJob
  include SuckerPunch::Job

  def perform(email)
    uri = URI.parse 'https://agileventures.slack.com/api/users.admin.invite'
    Net::HTTP.post_form(uri, {
      email: email,
      channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
      token: Slack::AUTH_TOKEN
    })
  end
end

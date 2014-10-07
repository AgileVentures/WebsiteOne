class SlackInviteJob
  include SuckerPunch::Job

  def perform(email)
    mechanize = Mechanize.new
    mechanize.post('https://agileventures.slack.com/api/users.admin.invite', {
      email: email,
      channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
      token: Slack::AUTH_TOKEN
    })
  end
end

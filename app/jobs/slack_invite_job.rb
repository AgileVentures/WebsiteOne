class SlackInviteJob
  include SuckerPunch::Job

  def perform(email)
    uri = URI.parse 'https://agileventures.slack.com/api/users.admin.invite'
    response = Net::HTTP.post_form(uri, {
      email: email,
      channels: 'C02G8J689,C0285CSUH,C02AA0ARR',
      token: Slack::AUTH_TOKEN
    })
    json_response = JSON.parse response.body
  # rescue
  #   # should alert admin
  # ensure
  #   if json_response.nil? or !json_response['ok']
  #     # alert admin
  #   end
  end
end

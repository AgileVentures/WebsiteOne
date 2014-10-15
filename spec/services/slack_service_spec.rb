require 'spec_helper'

describe SlackService do
   subject { SlackService }

   it 'sends a post request to the agile-bot with the proper data' do
     Features.slack.notifications.enabled = true
     stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify')
     user = User.new email: 'random@random.com'
     gravatar = CGI.escape 'https://www.gravatar.com/avatar/47548e7f026bc689ba743b2af2d391ee?d=retro'
     hangout = EventInstance.new(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user)

     subject.post_hangout_notification(hangout)

     assert_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify', times: 1) do |req|
       expect(req.body).to eq "title=MockEvent&link=mock_url&type=PairProgramming&host_name=random&host_avatar=#{gravatar}"
     end
   end
end

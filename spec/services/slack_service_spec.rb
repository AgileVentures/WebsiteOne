require 'spec_helper'

describe SlackService do
   subject { SlackService }

   it 'sends a post request to the agile-bot with the proper data' do
     Features.slack_notifications.enabled = true
     stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify')
     hangout = Hangout.new(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url")

     subject.post_hangout_notification(hangout)

     assert_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify', times: 1) do |req|
       expect(req.body).to eq 'title=MockEvent&link=mock_url&type=PairProgramming'
     end
   end
end

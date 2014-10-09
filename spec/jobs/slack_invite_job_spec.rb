require 'spec_helper'

describe SlackInviteJob do
  subject { SlackInviteJob.new }

   it 'sends a post request to invite the user to slack and returns the proper response' do
     stub_request(:post, 'https://agileventures.slack.com/api/users.admin.invite').
       to_return(body: '{"ok": true}')
     email = 'random@random.com'
     stub_const('Slack::AUTH_TOKEN', 'test')

     response = subject.perform(email)

     expect(response['ok']).to be_truthy
     assert_requested(:post, 'https://agileventures.slack.com/api/users.admin.invite', times: 1) do |req|
       expect(req.body).to eq "email=#{CGI.escape email}&channels=#{CGI.escape 'C02G8J689,C0285CSUH,C02AA0ARR'}&token=test"
     end
   end
end

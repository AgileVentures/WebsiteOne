require 'spec_helper'

describe SlackInviteJob do
  subject { SlackInviteJob.new }
  let(:email) { 'random@random.com' }
  before { stub_const('Slack::AUTH_TOKEN', 'test') }

  it 'sends a post request to invite the user to slack and returns the proper response' do
    stub_request(:post, 'https://agileventures.slack.com/api/users.admin.invite').
        to_return(body: '{"ok": true}')


    response = subject.perform(email)

    expect(response['ok']).to be_truthy
    assert_requested(:post, 'https://agileventures.slack.com/api/users.admin.invite', times: 1) do |req|
      expect(req.body).to eq "email=#{CGI.escape email}&channels=#{CGI.escape 'C02G8J689,C0285CSUH,C02AA0ARR'}&token=test"
    end
  end

  it 'when attempt errors we should notify admin' do
    error = StandardError.new 'boom!'
    expect(AdminMailer).to receive(:failed_to_invite_user_to_slack).with(email, error)

    stub_request(:post, 'https://agileventures.slack.com/api/users.admin.invite').
        and_raise(error)

    response = subject.perform(email)
  end

  it 'when slack response not ok should notify admin' do
    expect(AdminMailer).to receive(:failed_to_invite_user_to_slack).with(email, nil)

    stub_request(:post, 'https://agileventures.slack.com/api/users.admin.invite').
        to_return(body: '{"ok": false}')

    response = subject.perform(email)
  end
end

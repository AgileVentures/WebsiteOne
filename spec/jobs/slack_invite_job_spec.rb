# frozen_string_literal: true

RSpec.describe SlackInviteJob do
  subject { SlackInviteJob.new }
  let(:email) { 'random@random.com' }

  before { expect(Slack).to receive_message_chain(:config, :token).and_return 'test' }

  it 'sends a post request to invite the user to slack and returns the proper response' do
    stub_request(:post, SlackInviteJob::SLACK_INVITE_URL)
      .to_return(body: '{"ok": true}')

    response = subject.perform(email)

    expect(response['ok']).to be_truthy
    expect(WebMock).to have_requested(:post, SlackInviteJob::SLACK_INVITE_URL)
      .once
      .with { |request| request.body == "email=#{CGI.escape email}&channels=#{CGI.escape 'C02G8J689,C0285CSUH,C02AA0ARR'}&token=test" }
  end

  context 'when invite attempt fails notify admin' do
    let(:error) { StandardError.new 'boom!' }

    before do
      stub_request(:post, SlackInviteJob::SLACK_INVITE_URL).and_raise(error)
    end

    it 'sends the email later' do
      expect(AdminMailer).to receive_message_chain(:failed_to_invite_user_to_slack, :deliver_later)
      subject.perform(email)
    end

    it 'includes information about user and error' do
      allow(AdminMailer).to receive_message_chain(:failed_to_invite_user_to_slack, :deliver_later)
      expect(AdminMailer).to receive(:failed_to_invite_user_to_slack)
        .with(email, String, nil)
      subject.perform(email)
    end
  end

  context 'when slack response not ok should notify admin' do
    before do
      stub_request(:post, SlackInviteJob::SLACK_INVITE_URL)
        .to_return(body: '{"ok": false, "error": "already invited"}')
    end

    it 'sends the email later' do
      expect(AdminMailer).to receive_message_chain(:failed_to_invite_user_to_slack, :deliver_later)
      subject.perform(email)
    end

    it 'includes information about user and error' do
      allow(AdminMailer).to receive_message_chain(:failed_to_invite_user_to_slack, :deliver_later)
      expect(AdminMailer).to receive(:failed_to_invite_user_to_slack)
        .with(email, nil, '"already invited"')
      subject.perform(email)
    end
  end
end

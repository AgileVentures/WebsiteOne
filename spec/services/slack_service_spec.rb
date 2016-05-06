require 'spec_helper'

describe SlackService do
  subject { SlackService }

  let(:user) { User.new email: 'random@random.com' }
  let(:gravatar) { CGI.escape 'https://www.gravatar.com/avatar/47548e7f026bc689ba743b2af2d391ee?d=retro' }

  before { Features.slack.notifications.enabled = true }

  describe '.post_hangout_notification' do
    before { stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify') }

    let(:hangout) { EventInstance.create(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user) }

    it 'sends a post request to the agile-bot with the proper data' do
      hangout.project = Project.create( slug: 'edx')

      subject.post_hangout_notification(hangout)

      assert_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify', times: 1) do |req|
        expect(req.body).to eq "title=MockEvent&link=mock_url&type=PairProgramming&host_name=random&host_avatar=#{gravatar}&project=edx"
      end
    end

    it 'does not fail when event has no associated project' do
      subject.post_hangout_notification(hangout)

      assert_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify', times: 1) do |req|
        expect(req.body).to eq "title=MockEvent&link=mock_url&type=PairProgramming&host_name=random&host_avatar=#{gravatar}&project"
      end
    end

    it 'does not post notification if hangout url is blank' do
      hangout.hangout_url = "     "

      subject.post_hangout_notification(hangout)

      assert_not_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify')
    end
  end

  describe '.post_yt_link' do
    before { stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-video-notify') }

    let(:hangout) { EventInstance.create(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user) }

    it 'sends a post request to the agile-bot with the proper data' do
      hangout.yt_video_id = 'mock_url'
      hangout.project = Project.create( slug: 'localsupport')

      subject.post_yt_link(hangout)

      assert_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-video-notify', times: 1) do |req|
        expect(req.body).to eq "title=MockEvent&video=https%3A%2F%2Fyoutu.be%2Fmock_url&type=PairProgramming&host_name=random&host_avatar=#{gravatar}&project=localsupport"
      end
    end

    it 'does not post youtube video link if yt_video_id is blank' do
      hangout.yt_video_id = '    '

      subject.post_yt_link(hangout)

      assert_not_requested(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-video-notify')
    end
  end
end

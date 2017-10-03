require 'spec_helper'

describe SlackService do
  subject(:slack_service) { SlackService }

  let(:user) { User.new email: 'random@random.com' }

  before { Features.slack.notifications.enabled = true }

  describe '.post_hangout_notification' do
    let(:hangout) { EventInstance.create(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user) }
    let(:client) { double(:slack_client) }

    # @TODO Improve the message format to hide the URL details ... and welcome newcomers ...
    # @TODO we should pass in CHANNELS and GITTER ROOMS work out a way to handle that based on deployed instance, e.g staging, production etc.

    let(:general_channel_post_args) do
      {
          channel: 'C0TLAE1MH',
          text: 'MockEvent: mock_url',
          username: user.display_name,
          icon_url: user.gravatar_url,
          link_names: 1
      }
    end
    let(:project_channel_post_args) do
      {
          channel: 'C29J4QQ9W',
          text: '@here MockEvent: mock_url',
          username: user.display_name,
          icon_url: user.gravatar_url,
          link_names: 1
      }
    end
    let(:pairing_notifications_channel_post_args) do
      {
          channel: 'C29J3DPGW',
          text: '@channel MockEvent: mock_url',
          username: user.display_name,
          icon_url: user.gravatar_url,
          link_names: 1
      }
    end

    it 'sends the correct slack message to the correct channels for pairing' do
      hangout.project = Project.create(title: 'websiteone', description: 'hmm', status: 'active')

      expect(client).to receive(:chat_postMessage).with(general_channel_post_args)
      expect(client).to receive(:chat_postMessage).with(project_channel_post_args)
      expect(client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

      slack_service.post_hangout_notification(hangout, client)
    end

    it 'does not fail when event has no associated project for pairing' do

      expect(client).to receive(:chat_postMessage).with(general_channel_post_args)
      expect(client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

      slack_service.post_hangout_notification(hangout, client)
    end

    xit 'should ping gitter when the project is cs169'
    xit 'sends the correct slack message to the correct channels for scrums'
    xit 'does not fail when event has no associated project for scrums'
    xit 'does not post notification if hangout url is blank for scrums'

    it 'does not post notification if hangout url is blank for pairing' do
      hangout.hangout_url = "     "

      expect(client).not_to receive(:chat_postMessage)

      slack_service.post_hangout_notification(hangout)
    end
  end

  describe '.post_yt_link' do
    let(:hangout) { EventInstance.create(title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user) }
    let(:client) { spy(:slack_client) }
    let(:expected_post_args) do
      {
        text: 'Video/Livestream for MockEvent: https://youtu.be/mock_url',
        username: user.display_name,
        icon_url: user.gravatar_url,
        link_names: 1
      }
    end

    it 'sends the correct slack message to the correct channels for pairing' do
      hangout.yt_video_id = 'mock_url'
      hangout.project = Project.create(slug: 'websiteone', title: 'WebSiteOne', description: 'hmmm', status: 'active')

      slack_service.post_yt_link(hangout, client)

      expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: 'C0TLAE1MH'))
      expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: 'C29J4QQ9W'))
    end

    xit 'sends the correct slack message to the correct channels for scrums'
    xit 'does not post youtube video link if yt_video_id is blank for scrums'

    it 'does not post youtube video link if yt_video_id is blank for pairing' do
      hangout.yt_video_id = '    '
      slack_service.post_yt_link(hangout, client)

      expect(client).not_to have_received(:chat_postMessage)
    end
  end
end

# frozen_string_literal: true

describe YoutubeNotificationService do
  subject(:youtube_notification_service) { YoutubeNotificationService }
  before { Features.slack.notifications.enabled = true }

  let(:user) { User.new email: 'random@random.com' }
  let(:slack_client) { double(:slack_client) }
  let(:general_channel_id) { 'C0TLAE1MH' }
  let(:pairing_notifications_channel_id) { 'C29J3DPGW' }
  let(:websiteone_channel_id) { 'C29J4QQ9W' }
  let(:premium_extra_channel_id) { 'C29J4QQ9M' }
  let(:premium_mob_trialists_channel_id) { 'C29J4QQ9F' }
  let(:new_members_channel_id) { 'C02G8J699' }

  describe '.post_yt_link' do
    let(:client) { spy(:slack_client) }

    let(:expected_post_args) do
      {
        text: 'Video/Livestream: <https://youtu.be/mock_url|click to play>',
        username: user.display_name,
        icon_url: user.gravatar_url,
        link_names: 1
      }
    end

    context('PairProgramming') do
      let(:event_instance) do
        EventInstance.create(title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                             event_id: event_with_slack_channels.id)
      end
      let(:event_with_slack_channels) do
        FactoryBot.create(:event, slack_channels: Array(SlackChannel.create({ code: 'C02G8J699' })))
      end

      before { allow(event_instance).to receive(:for).and_return '' }

      it 'sends the correct slack message to the correct channels' do
        event_instance.yt_video_id = 'mock_url'
        slack_channel = SlackChannel.create(code: 'C29J4QQ9W')
        event_instance.project = Project.create(title: 'WebSiteOne', description: 'hmmm', status: 'active',
                                                slack_channels: [slack_channel])

        youtube_notification_service.with event_instance, client
        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: general_channel_id))
        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: websiteone_channel_id))
        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: new_members_channel_id))
      end

      it 'does not ping slack when the project is cs169' do
        event_instance.yt_video_id = 'mock_url'
        slack_channel = SlackChannel.create(code: 'C29J4CYA2')
        event_instance.project = Project.create(title: 'cs169', description: 'hmmm', status: 'active',
                                                slack_channels: [slack_channel])

        youtube_notification_service.with event_instance, client
        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: general_channel_id))
        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: websiteone_channel_id))
      end

      it 'does not post youtube video link if yt_video_id is blank' do
        event_instance.yt_video_id = '    '
        youtube_notification_service.with event_instance, client

        expect(client).not_to have_received(:chat_postMessage)
      end
    end

    context('Scrums') do
      let(:event_instance) do
        EventInstance.create(title: 'MockEvent', category: 'Scrum', hangout_url: 'mock_url', user: user)
      end
      before { allow(event_instance).to receive(:for).and_return '' }

      it 'sends the correct slack message to the correct channels' do
        event_instance.yt_video_id = 'mock_url'
        slack_channel = SlackChannel.create(code: 'C29J4QQ9W')
        event_instance.project = Project.create(slug: 'websiteone', title: 'WebSiteOne', description: 'hmmm',
                                                status: 'active', slack_channels: [slack_channel])

        youtube_notification_service.with(event_instance, client)

        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: general_channel_id))
        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: websiteone_channel_id))
      end

      it 'does not post youtube video link if yt_video_id is blank' do
        event_instance.yt_video_id = '    '
        youtube_notification_service.with(event_instance, client)

        expect(client).not_to have_received(:chat_postMessage)
      end
    end

    context 'Premium Mob Members Events' do
      let(:event_instance) do
        EventInstance.create(title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user)
      end
      before { allow(event_instance).to receive(:for).and_return 'Premium Mob Members' }

      it 'posts youtube url to appropriate private channels' do
        event_instance.yt_video_id = 'mock_url'
        event_instance.project = Project.create(slug: 'websiteone', title: 'WebSiteOne', description: 'hmmm',
                                                status: 'active')

        youtube_notification_service.with(event_instance, client)

        expect(client).to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: premium_extra_channel_id))
        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: premium_mob_trialists_channel_id))
        expect(client).to have_received(:chat_postMessage).with(hash_including(channel: premium_extra_channel_id)).once
      end

      it 'does not post youtube url to public channels' do
        event_instance.yt_video_id = 'mock_url'
        event_instance.project = Project.create(slug: 'websiteone', title: 'WebSiteOne', description: 'hmmm',
                                                status: 'active')

        youtube_notification_service.with(event_instance, client)

        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: general_channel_id))
        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: pairing_notifications_channel_id))
        expect(client).not_to have_received(:chat_postMessage).with(expected_post_args.merge!(channel: websiteone_channel_id))
      end
    end
  end
end

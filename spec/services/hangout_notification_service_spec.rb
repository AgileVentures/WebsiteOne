# frozen_string_literal: true

describe HangoutNotificationService do
  subject(:hangout_notification_service) { HangoutNotificationService }
  let(:slack_client) { double(:slack_client) }
  let(:gitter_client) { double(:gitter_client) }

  let(:default_post_args) do
    {
      username: user.display_name,
      icon_url: user.gravatar_url,
      link_names: 1
    }
  end

  let(:message) { 'MockEvent: <mock_url|click to join>' }
  let(:here_message) { "@here #{message}" }
  let(:channel_message) { "@channel #{message}" }

  let(:general_channel_post_args) do
    {
      channel: 'C0TLAE1MH',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:websiteone_project_channel_post_args) do
    {
      channel: 'C29J4QQ9W',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:pairing_notifications_channel_post_args) do
    {
      channel: 'C29J3DPGW',
      text: channel_message
    }.merge!(default_post_args)
  end
  let(:cs169_project_channel_post_args) do
    {
      channel: 'C29J4CYA2',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:localsupport_project_channel_post_args) do
    {
      channel: 'C69J9GC1Y',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:standup_notifications_channel_post_args) do
    {
      channel: 'C29JE6HGR',
      text: channel_message
    }.merge!(default_post_args)
  end
  let(:post_premium_mob_notification_post_args) do
    {
      channel: 'C29J4QQ9M',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:post_premium_mob_trialists_notification_post_args) do
    {
      channel: 'C29J4QQ9F',
      text: here_message
    }.merge!(default_post_args)
  end
  let(:new_members_notification_post_args) do
    {
      channel: 'C02G8J699',
      text: here_message
    }.merge!(default_post_args)
  end

  let(:user) { User.new email: 'random@random.com' }
  let(:websiteone_project) { mock_model Project, slug: 'websiteone', slack_channel_codes: ['C29J4QQ9W'] }
  let(:noslack_project) { mock_model Project, slug: 'noslack', slack_channel_codes: [] }
  let(:cs169_project) { mock_model Project, slug: 'cs169', slack_channel_codes: ['C29J4CYA2'] }
  let(:multiple_channel_project) do
    mock_model Project, slug: 'multiple-channels', slack_channel_codes: %w(C29J4QQ9W C69J9GC1Y)
  end

  before { Features.slack.notifications.enabled = true }

  describe '.post_hangout_notification' do
    let(:event_with_slack_channels) do
      FactoryBot.create(:event, slack_channels: Array(SlackChannel.create({ code: 'C02G8J699' })))
    end
    let(:websiteone_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: websiteone_project, for: ''
    end
    let(:no_project_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: nil, for: ''
    end
    let(:project_with_no_slack_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: noslack_project, for: ''
    end
    let(:cs169_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: cs169_project, for: ''
    end
    let(:missing_url_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: '  ', user: user, for: ''
    end
    let(:multiple_channel_hangout) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: multiple_channel_project, for: ''
    end
    let(:event_instance_with_event_slack_channels) do
      mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                project: websiteone_project, for: '', event_id: event_with_slack_channels.id
    end

    before do
      allow(websiteone_hangout).to receive(:channels_for_event).and_return([])
      allow(no_project_hangout).to receive(:channels_for_event).and_return([])
      allow(project_with_no_slack_hangout).to receive(:channels_for_event).and_return([])
      allow(cs169_hangout).to receive(:channels_for_event).and_return([])
      allow(missing_url_hangout).to receive(:channels_for_event).and_return([])
      allow(multiple_channel_hangout).to receive(:channels_for_event).and_return([])
      allow(event_instance_with_event_slack_channels).to receive(:channels_for_event).and_return(['C02G8J699'])
    end

    context 'PairProgramming' do
      it 'sends the correct slack message to the correct channels when associated with a project' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(websiteone_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

        hangout_notification_service.with(websiteone_hangout, slack_client, gitter_client)
      end

      it 'does not fail when event has no associated project' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

        hangout_notification_service.with(no_project_hangout, slack_client, gitter_client)
      end

      it 'does not try to post to slack channel when project has no associated slack channel in lookup table' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

        hangout_notification_service.with(project_with_no_slack_hangout, slack_client, gitter_client)
      end

      it 'should ping gitter and slack (but not general) when the project is cs169' do
        expect(gitter_client).to receive(:messages).with('56b8bdffe610378809c070cc', limit: 50).and_return([])
        expect(gitter_client).to receive(:send_message).with('[MockEvent with random](mock_url) is starting NOW!',
                                                             '56b8bdffe610378809c070cc')
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(cs169_project_channel_post_args)

        hangout_notification_service.with(cs169_hangout, slack_client, gitter_client)
      end

      it 'does not post notification if hangout url is blank' do
        expect(slack_client).not_to receive(:chat_postMessage)

        hangout_notification_service.with(missing_url_hangout, slack_client, gitter_client)
      end

      it 'can post to multiple channels' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(websiteone_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(localsupport_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)

        hangout_notification_service.with(multiple_channel_hangout, slack_client, gitter_client)
      end

      it 'sends the correct slack message to the correct channels when associated with an event' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(websiteone_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(pairing_notifications_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(new_members_notification_post_args)

        hangout_notification_service.with(event_instance_with_event_slack_channels, slack_client, gitter_client)
      end
    end

    context('Scrums') do
      let(:cs169_hangout) do
        mock_model EventInstance, title: 'MockEvent', category: 'Scrum', hangout_url: 'mock_url', user: user,
                                  project: cs169_project, for: ''
      end
      let(:missing_url_hangout) do
        mock_model EventInstance, title: 'MockEvent', category: 'Scrum', hangout_url: '  ', user: user, for: ''
      end
      let(:websiteone_hangout) do
        mock_model EventInstance, title: 'MockEvent', category: 'Scrum', hangout_url: 'mock_url', user: user,
                                  project: websiteone_project, for: ''
      end
      let(:no_project_hangout) do
        mock_model EventInstance, title: 'MockEvent', category: 'Scrum', hangout_url: 'mock_url', user: user, project: nil,
                                  for: ''
      end

      it 'sends the correct slack message to the correct channels' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(websiteone_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(standup_notifications_channel_post_args)

        hangout_notification_service.with(websiteone_hangout, slack_client, gitter_client)
      end

      it 'does not fail when event has no associated project' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(standup_notifications_channel_post_args)

        hangout_notification_service.with(no_project_hangout, slack_client, gitter_client)
      end

      it 'should ping slack when the project is cs169' do
        expect(slack_client).to receive(:chat_postMessage).with(general_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(cs169_project_channel_post_args)
        expect(slack_client).to receive(:chat_postMessage).with(standup_notifications_channel_post_args)

        hangout_notification_service.with(cs169_hangout, slack_client, gitter_client)
      end

      it 'does not post notification if hangout url is blank for pairing' do
        expect(slack_client).not_to receive(:chat_postMessage)

        hangout_notification_service.with(missing_url_hangout, slack_client, gitter_client)
      end
    end

    context 'Premium Mob Members Events' do
      let(:premium_mob_hangout) do
        mock_model EventInstance, title: 'MockEvent', category: 'PairProgramming', hangout_url: 'mock_url', user: user,
                                  project: websiteone_project, for: 'Premium Mob Members'
      end
      let(:general_channel_id) { 'C0TLAE1MH' }
      let(:pairing_notifications_channel_id) { 'C29J3DPGW' }
      let(:websiteone_channel_id) { 'C29J4QQ9W' }

      before { allow(premium_mob_hangout).to receive(:channels_for_event).and_return([]) }

      it 'posts hangout url to appropriate private channels' do
        expect(slack_client).to receive(:chat_postMessage).with(post_premium_mob_notification_post_args).once
        expect(slack_client).to receive(:chat_postMessage).with(post_premium_mob_trialists_notification_post_args).once

        hangout_notification_service.with(premium_mob_hangout, slack_client)
      end

      it 'does not post hangout url to public channels' do
        expect(slack_client).not_to receive(:chat_postMessage).with hash_including(channel: general_channel_id)
        expect(slack_client).not_to receive(:chat_postMessage).with hash_including(channel: pairing_notifications_channel_id)
        expect(slack_client).not_to receive(:chat_postMessage).with hash_including(channel: websiteone_channel_id)

        hangout_notification_service.with(premium_mob_hangout, slack_client)
      end
    end
  end
end

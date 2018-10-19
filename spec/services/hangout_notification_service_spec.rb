require 'spec_helper'

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
        text: here_message,
    }.merge!(default_post_args)
  end
  let(:websiteone_project_channel_post_args) do
    {
        channel: 'C29J4QQ9W',
        text: here_message,
    }.merge!(default_post_args)
  end
  let(:pairing_notifications_channel_post_args) do
    {
        channel: 'C29J3DPGW',
        text: channel_message,
    }.merge!(default_post_args)
  end
  let(:cs169_project_channel_post_args) do
    {
        channel: 'C29J4CYA2',
        text: here_message,
    }.merge!(default_post_args)
  end
  let(:localsupport_project_channel_post_args) do
    {
        channel: 'C69J9GC1Y',
        text: here_message,
    }.merge!(default_post_args)
  end
  let(:standup_notifications_channel_post_args) do
    {
        channel: 'C29JE6HGR',
        text: channel_message,
    }.merge!(default_post_args)
  end
  let(:post_premium_mob_notification_post_args) do 
    {
      channel: 'C29J4QQ9M',
      text: here_message,
    }.merge!(default_post_args)
  end
  let(:post_premium_mob_trialists_notification_post_args) do 
    {
      channel: 'C29J4QQ9F',
      text: here_message,
    }.merge!(default_post_args)
  end

  let(:user) { User.new email: 'random@random.com' }
  let(:websiteone_project) { mock_model Project, slug: 'websiteone' }
  let(:noslack_project) { mock_model Project, slug: 'noslack' }
  let(:cs169_project) { mock_model Project, slug: 'cs169' }
  let(:multiple_channel_project) { mock_model Project, slug: 'multiple-channels' }

  before { Features.slack.notifications.enabled = true }
  
  describe '.post_hangout_notification' do
    let(:websiteone_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: websiteone_project, for: '' }
    let(:no_project_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: nil, for: '' }
    let(:project_with_no_slack_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: noslack_project, for: '' }
    let(:cs169_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: cs169_project, for: '' }
    let(:missing_url_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "  ", user: user, for: '' }
    let(:multiple_channel_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: multiple_channel_project, for: '' }
    
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
        expect(gitter_client).to receive(:send_message).with('[MockEvent with random](mock_url) is starting NOW!', "56b8bdffe610378809c070cc")
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
    end
    
    context('Scrums') do
      let(:cs169_hangout) { mock_model EventInstance, title: 'MockEvent', category: "Scrum", hangout_url: "mock_url", user: user, project: cs169_project, for: ''  }
      let(:missing_url_hangout) { mock_model EventInstance, title: 'MockEvent', category: "Scrum", hangout_url: "  ", user: user, for: ''  }
      let(:websiteone_hangout) { mock_model EventInstance, title: 'MockEvent', category: "Scrum", hangout_url: "mock_url", user: user, project: websiteone_project, for: ''  }
      let(:no_project_hangout) { mock_model EventInstance, title: 'MockEvent', category: "Scrum", hangout_url: "mock_url", user: user, project: nil, for: ''  }
      
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
      let(:premium_mob_hangout) { mock_model EventInstance, title: 'MockEvent', category: "PairProgramming", hangout_url: "mock_url", user: user, project: websiteone_project, for: 'Premium Mob Members' }
      let(:general_channel_id) { 'C0TLAE1MH' }
      let(:pairing_notifications_channel_id) { 'C29J3DPGW' }
      let(:websiteone_channel_id) { 'C29J4QQ9W' }
      
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

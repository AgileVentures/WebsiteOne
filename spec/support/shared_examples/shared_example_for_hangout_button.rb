# frozen_string_literal: true

include ProjectsHelper

shared_examples_for 'it has a hangout button' do
  before do
    allow_message_expectations_on_nil
    allow(view).to receive(:generate_event_instance_id).and_return('123456')
    allow(view.current_user).to receive(:id).and_return('user_1')
  end

  context 'with Settings.hangouts.ssl_host' do
    let(:data_tags) do
      start_data =  JSON.generate({
                                    'title' => title,
                                    'category' => category,
                                    'projectId' => project_id.to_s.squish,
                                    'eventId' => event_id.to_s.squish,
                                    'hostId' => 'user_1',
                                    'hangoutId' => '123456',
                                    'callbackUrl' => 'https://my_fancy_host.com/hangouts/'
                                  })
      {
        'data-start-data' => start_data,
        'data-app-id' => Settings.hangouts.app_id
      }
    end

    it 'renders hangout button with data_tags' do
      allow(Settings.hangouts).to receive(:ssl_host).and_return('my_fancy_host.com')
      render
      expect(rendered).to have_tag('div#liveHOA-placeholder', with: data_tags)
    end
  end

  context 'without Settings.hangouts.ssl_host' do
    let(:data_tags) do
      start_data =  JSON.generate({
                                    'title' => title,
                                    'category' => category,
                                    'projectId' => project_id.to_s.squish,
                                    'eventId' => event_id.to_s.squish,
                                    'hostId' => 'user_1',
                                    'hangoutId' => '123456',
                                    'callbackUrl' => 'https://test.host/hangouts/'
                                  })
      {
        'data-start-data' => start_data,
        'data-app-id' => Settings.hangouts.app_id
      }
    end

    it 'renders hangout button with data_tags' do
      allow(Settings.hangouts).to receive(:ssl_host).and_return(nil)
      render
      expect(rendered).to have_tag('div#liveHOA-placeholder', with: data_tags)
    end
  end
end

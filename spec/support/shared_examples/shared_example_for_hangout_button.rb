include ProjectsHelper

shared_examples_for 'it has a hangout button' do
  let(:data_tags) do
    {
      'data-topic' => topic_name,
      'data-event-id' => event_id.to_s.squish,
      'data-category' => category,
      'data-hangout-id' => '123456',
      'data-app-id' => Settings.hangouts.app_id,
      'data-callback-url' => hangout_url('id').gsub(/id$/, '')
    }
  end

  it 'renders hangout button with correct parameters' do
    allow(view).to receive(:generate_hangout_id).and_return('123456')
    render
    expect(rendered).to have_selector('#liveHOA-placeholder', data_tags)
  end
end

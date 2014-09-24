include ProjectsHelper

shared_examples_for 'it has a hangout button' do
  before do
    allow(view).to receive(:generate_event_instance_id).and_return('123456')
    allow(view.current_user).to receive(:id).and_return('user_1')
  end

  let(:data_tags) do
    start_data =  JSON.generate({
      'title' => title,
      'category' => category,
      'projectId' => project_id.to_s.squish,
      'eventId' => event_id.to_s.squish,
      'hostId' => 'user_1',
      'hangoutId' => '123456',
      'callbackUrl' => hangout_url('id').gsub(/id$/, '') })
    {
      'data-start-data' => start_data,
      'data-app-id' => Settings.hangouts.app_id
    }
  end

  it 'renders hangout button with generated hangout id if provided id is empty' do
    render
    expect(rendered).to have_selector('#liveHOA-placeholder', data_tags)
  end

  it 'renders hangout button with provided id if it is not empty' do
    render
    expect(rendered).to have_selector('#liveHOA-placeholder', data_tags)
  end
end

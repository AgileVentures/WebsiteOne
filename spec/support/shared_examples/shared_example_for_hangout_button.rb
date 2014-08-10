include ProjectsHelper

shared_examples_for 'it has a hangout button' do
  before do
    allow(view).to receive(:generate_hangout_id).and_return('123456')
    allow(view.current_user).to receive(:id).and_return('user_1')
  end

  let(:data_tags) do
    {
      'data-title' => title,
      'data-project-id' => project_id.to_s.squish,
      'data-event-id' => event_id.to_s.squish,
      'data-category' => category,
      'data-hangout-id' => '123456',
      'data-host-id' => 'user_1',
      'data-app-id' => Settings.hangouts.app_id,
      'data-callback-url' => hangout_url('id').gsub(/id$/, '')
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

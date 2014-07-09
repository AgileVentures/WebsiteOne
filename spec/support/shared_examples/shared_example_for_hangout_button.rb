shared_examples_for 'it has a hangout button' do
  let(:data_tags) do 
    data_tags = {
      'data-topic' => topic_name,
      'data-app-id' => Settings.hangouts.app_id,
      'data-callback-url' => hangout_url(id)
    }
  end

  it 'renders hangout button with correct parameters' do
    render
    expect(rendered).to have_selector('#liveHOA-placeholder', data_tags)
  end
end

shared_examples_for 'it has clickable user avatar with popover' do
  before do
    allow_any_instance_of(UserPresenter).to receive(:display_name).and_return('user_name')
    allow_any_instance_of(UserPresenter).to receive(:gravatar_image).and_return('user_gravatar')
  end

  it 'renders user avatar' do
    render
    expect(rendered).to have_text('user_gravatar')
  end

  it 'renders link to user profile' do
    render
    expect(rendered).to have_link('', href: user_path(user))
  end

  it 'renders a popover with user details' do
    data_tags = { 'class' => 'user-popover',
                  'data-html' => 'true',
                  'data-container' => 'body',
                  'data-toggle' => 'popover',
                  'data-placement' => placement}

    popover_content = 'Member for: <br/>User rating: <br/>PP sessions:'
    user_tags = { 'data-title' => 'user_name',
                  'data-content' => popover_content }
    render
    expect(rendered).to have_selector('a', data_tags)
    expect(rendered).to have_selector('a', user_tags)
  end
end

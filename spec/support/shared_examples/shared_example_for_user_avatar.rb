shared_examples_for 'it has clickable user avatar with popover' do
  before do
    allow_any_instance_of(UserPresenter).to receive(:display_name).and_return('user_name')
    allow_any_instance_of(UserPresenter).to receive(:gravatar_image).and_return('user_gravatar')
    allow_any_instance_of(UserPresenter).to receive(:profile_link).and_return('profile_link')
    allow_any_instance_of(UserPresenter).to receive(:object_age_in_words).and_return('11 days')
  end

  it 'renders a popover with user details' do
    popover_content = 'Member for: 11 days<br/>User rating: <br/>PP sessions:'
    render

    expect(rendered).to match(/data-title="user_name"/)
    expect(rendered).to match(/data-placement="#{placement}"/)
    expect(rendered).to match(/data-content="#{popover_content}"/)
    expect(rendered).to match(/user_gravatar/)
    expect(rendered).to match(/href="profile_link"/)

  end
end

# frozen_string_literal: true

shared_examples_for 'it has clickable user avatar with popover' do
  before do
    allow_any_instance_of(UserPresenter).to receive(:display_name).and_return('user_name')
    allow_any_instance_of(UserPresenter).to receive(:gravatar_image).and_return('user_gravatar')
    allow_any_instance_of(UserPresenter).to receive(:profile_link).and_return('profile_link')
  end

  it 'renders a user link with title' do
    render

    expect(rendered).to match(/user_name/)
    expect(rendered).to match(/user_gravatar/)
    expect(rendered).to match(/href="profile_link"/)
  end
end

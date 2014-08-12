shared_examples_for 'it has clickable user avatar with popover' do
  before do
    allow_any_instance_of(UserPresenter).to receive(:display_name).and_return('user_name')
    allow_any_instance_of(UserPresenter).to receive(:gravatar_image).and_return('user_gravatar')
  end

  it 'renders a popover with user details' do
    render
    expect(rendered).to match /#{user.presenter.user_avatar_with_popover({ placement: placement })}/
  end
end

shared_examples 'commentable with Disqus' do
  let(:data_tags) {
    data_tags = {
      'data-disqus-shortname' => Settings.disqus.shortname,
      'data-disqus-identifier' => entity.friendly_id,
      'data-disqus-title' => entity.title,
      'data-disqus-url' => 'test.com'
    }
  }

  before :each do
    allow(controller.request).to receive(:url).and_return('test.com')
  end

  it 'renders Disqus_thread with parameters for Document' do
    # allow(entity).to receive(:friendly_id).and_return(entity.title)
    render
    expect(rendered).to have_selector('#disqus_thread', data_tags)
  end

  it 'embeds single-sign-on script if user is logged in' do
    allow(view).to receive(:current_user).and_return(stub_model(User))
    allow(view).to receive(:user_signed_in?).and_return(true)
    render
    expect(rendered).to have_selector('script#disqus-sso')
  end
end

# frozen_string_literal: true

shared_examples 'commentable with Disqus' do
  let(:data_tags) do
    data_tags = {
      'data-disqus-shortname' => Settings.disqus.shortname,
      'data-disqus-identifier' => entity.friendly_id,
      'data-disqus-title' => entity.title,
      'data-disqus-url' => 'test.com'
    }
  end

  before :each do
    allow(controller.request).to receive(:url).and_return('test.com')
  end

  it 'renders Disqus_thread with parameters for Document' do
    render
    expect(rendered).to have_tag('div#disqus_thread', data_tags)
  end

  it 'embeds single-sign-on script if user is logged in' do
    allow(view).to receive(:current_user).and_return(stub_model(User))
    allow(view).to receive(:user_signed_in?).and_return(true)
    render
    expect(rendered).to have_tag('script', id: 'disqus-sso')
  end
end

shared_examples 'commentable with Disqus' do
  let(:data_tags) { 
    data_tags = {
      'data-disqus-shortname' => Disqus::DISQUS_SHORTNAME,
      'data-disqus-identifier' => entity.friendly_id,
      'data-disqus-title' => entity.title,
      'data-disqus-url' => 'test.com'
    }
  }

  it 'renders Disqus_thread with parameters for Document' do
    controller.request.stub(url: 'test.com')
    render
    expect(rendered).to have_selector('#disqus_thread', data_tags)
  end
end

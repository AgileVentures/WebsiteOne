require 'spec_helper'

describe DisqusHelper do
  it 'renders Disqus embed with parameters for Article' do
    @article = double(Article, id: 555, title: 'Ruby article')
    article_path = article_path(@article, only_path: false)

    render_disqus_for(:article)

    expect(rendered).to include("disqus_shortname = '#{DISQUS_SHORTNAME}'")
    expect(rendered).to include("disqus_title = 'Ruby article'")
    expect(rendered).to include("disqus_identifier = 'article_555'")
    expect(rendered).to include("disqus_url = '#{article_path}'")
  end


  it 'renders Disqus embed with parameters for Document' do
    @document = double(Document, id: 555, title: 'Child Title')
    @project = double(Project, id: 1, title: 'Project')
    document_path = project_document_path(@project, @document, only_path: false)

    render_disqus_for(:document)

    expect(rendered).to include("disqus_shortname = '#{DISQUS_SHORTNAME}'")
    expect(rendered).to include("disqus_title = 'Child Title'")
    expect(rendered).to include("disqus_identifier = 'document_555'")
    expect(rendered).to include("disqus_url = '#{document_path}'")
  end


  it 'does not render Disqus when inside Mercury editor ' do
    request = controller.request
    request.stub(original_url: 'mercury_frame=true')
    
    render_disqus_for(:document)

    expect(rendered).not_to have_css("#disqus_thread")
  end
end

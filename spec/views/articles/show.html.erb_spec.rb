require 'spec_helper'

describe 'articles/show' do
  before(:each) do
    @user = stub_model(User, display_name: 'Thomas')
    @author = @user
    @article =  stub_model(Article,
                           :id => 555,
                           :title => "Ruby article",
                           :content => "My Ruby content",
                           :tag_list => ["Ruby", "Rails"],
                           :user => @user,
                           :created_at => Time.now,
                           :updated_at => Time.now)
  end

  context 'user is not signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should show article content' do
      render
      rendered.should have_css('div#doc-box')
      rendered.should have_text(@article.title)
      rendered.should have_content("Created on #{@article.created_at.strftime('%d %B %y')}")
      rendered.should have_content("Last updated #{time_ago_in_words(@article.updated_at)}")
      rendered.should have_text(@article.tag_list.join(', '))
      rendered.should_not have_link('edit article')
    end

  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    it 'renders a edit button' do
      render
      rendered.should have_link('edit article')
    end
  end

  describe 'rendering Disqus' do
    it 'renders Disqus_thread container' do
      render
      expect(rendered).to have_css("#disqus_thread")
    end

    it 'includes Disqus embed script with correct params' do
      render
      expect(rendered).to include("disqus_shortname = '#{DISQUS_SHORTNAME}'")
      expect(rendered).to include("disqus_title = 'Ruby article'")
      expect(rendered).to include("disqus_identifier = 'article_555'")
      expect(rendered).to include("disqus_url = '#{article_path(@article, only_path: false)}'")
    end
  end

end

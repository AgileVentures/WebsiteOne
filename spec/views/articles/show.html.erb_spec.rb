require 'spec_helper'

describe 'articles/show', type: :view do
  before(:each) do
    @user = stub_model(User, display_name: 'Thomas')
    @author = @user
    @article =  stub_model(Article,
                           :id => 555,
                           :friendly_id => 'friendly_id',
                           :title => "Ruby article",
                           :content => "My Ruby content",
                           :tag_list => ["Ruby", "Rails"],
                           :user => @user,
                           :created_at => Time.now,
                           :updated_at => Time.now)
  end

  context 'user is not signed in' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it 'should show article content' do
      render
      expect(rendered).to have_css('div#doc-box')
      expect(rendered).to have_text(@article.title)
      expect(rendered).to have_content("Created on #{@article.created_at.strftime('%d %B %y')}")
      expect(rendered).to have_content("Last updated #{time_ago_in_words(@article.updated_at)}")
      expect(rendered).to have_text(@article.tag_list.join(', '))
      expect(rendered).not_to have_link('edit article')
    end

  end

  context 'user is signed in' do
    before :each do
      allow(view).to receive(:current_user).and_return(@user)
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it 'renders a edit button' do
      render
      expect(rendered).to have_link('edit article')
    end
  end

  describe 'renders Disqus section' do
    it_behaves_like 'commentable with Disqus' do
      let(:entity) { @article }
    end
  end
end

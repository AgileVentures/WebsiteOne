require 'spec_helper'

describe 'articles/index' do

  before(:each) do
    @user1 = build_stubbed(:user, first_name: 'Thomas')
    @user2 = build_stubbed(:user, first_name: 'Bryan')

    @articles = [
      build_stubbed(:article, title: 'Ruby article',   content: 'My Ruby content',   tag_list: ["Ruby", "Rails"],        user: @user1, created_at: Time.now),
      build_stubbed(:article, title: 'jQuery article', content: 'My jQuery Content', tag_list: ["Javascript", "jQuery"], user: @user2, created_at: Time.now)
    ]
  end

  it 'should render an article list' do
    render
    expect(rendered).to have_selector('div.article-list')
    rendered.within('div.article-list') do |article|
      expect(article).to have_text('Created by Thomas')
      expect(article).to have_text('Created by Bryan')
      expect(article).to have_text('Ruby article')
      expect(article).to have_text('jQuery article')
      expect(article).to have_text('My Ruby content')
      expect(article).to have_text('My jQuery Content')
    end
  end
end

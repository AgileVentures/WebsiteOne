require 'spec_helper'

describe 'articles/index' do

  before(:each) do
    @user1 = stub_model(User, display_name: 'Thomas')
    @user2 = stub_model(User, display_name: 'Bryan')
    @articles =  [
        stub_model(Article, :title => "Ruby article",:content => "My Ruby content", :tag_list => ["Ruby", "Rails"], :user => @user1, :created_at => Time.now),
        stub_model(Article, :title => "jQuery article", :content => "My jQuery Content", :tag_list=> ["Javascript", "jQuery"], :user => @user2, :created_at => Time.now)
    ]
  end


  it 'should render an article list' do
    render
    rendered.should have_selector('div.article-list')
    rendered.within('div.article-list') do |article|
      article.should have_text('Created by Thomas')
      article.should have_text('Created by Bryan')
      article.should have_text('Ruby article')
      article.should have_text('jQuery article')
      article.should have_text('My Ruby content')
      article.should have_text('My jQuery Content')
    end
  end

end
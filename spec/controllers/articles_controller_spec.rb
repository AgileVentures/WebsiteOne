require 'spec_helper'

describe ArticlesController do
  describe 'GET index' do
    before(:each) do
      @articles = (1..7).collect { double('Article', tag_list: 'Javascript' ) }
      @ruby_rails_articles = @articles[0..3]
      @ruby_rails_articles.each { |a| a.stub(:tag_list).and_return('Ruby, Rails') }
    end

    it 'should render the index template for all possible paths' do
      get :index
      expect(response).to render_template :index
      get :index, params: { tag: 'Javascript' }
      expect(response).to render_template :index
    end

    it 'should assign all articles to @articles' do
      expect(Article).to receive(:order).and_return(@articles)
      @articles.stub(:includes).and_return(@articles)
      get :index
      expect(assigns(:articles)).to eq @articles
    end

    it 'should be able to filter by tags' do
      expect(Article).to receive(:tagged_with).with('Ruby')
      Article.stub_chain("tagged_with.order").and_return(@ruby_rails_articles)
      @ruby_rails_articles.stub(:includes).and_return(@ruby_rails_articles)
      get :index, params: { tag: 'Ruby' }
      expect(assigns(:articles)).to eq @ruby_rails_articles
    end
  end

  describe 'GET show' do
    before(:each) do
      @author = double('User')
      @article = double('Article', friendly_id: 'friend', user: @author)
      Article.stub_chain("friendly.find").and_return(@article)
    end

    it 'should render the show template' do
      get :show, params: { id: @article.friendly_id }
      expect(response).to render_template :show
    end

    it 'should search the database using the friendly id' do
      dummy = Object.new
      expect(Article).to receive(:friendly).and_return(dummy)
      expect(dummy).to receive(:find).with(@article.friendly_id).and_return(@article)
      get :show, params: { id: @article.friendly_id }
    end

    it 'should assign the requested article to @article' do
      get :show, params: { id: @article.friendly_id }
      expect(assigns(:article)).to eq @article
    end

    it 'should assign the requested article author to @author' do
      get :show, params: { id: @article.friendly_id }
      expect(assigns(:author)).to eq @author
    end
  end
end

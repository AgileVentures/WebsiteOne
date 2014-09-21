require 'spec_helper'

describe ArticlesController do

  let (:valid_params) { { article: { 'title' => 'title',
                                     'content' => 'Content',
                                     'tag_list' => 'Ruby on Rails' } } }

  describe 'GET index' do
    before(:each) do
      @articles = (1..7).collect { double('Article', tag_list: 'Javascript' ) }
      @ruby_rails_articles = @articles[0..3]
      @ruby_rails_articles.each { |a| a.stub(:tag_list).and_return('Ruby, Rails') }
    end

    it 'should render the index template for all possible paths' do
      get :index
      expect(response).to render_template :index
      get :index, tag: 'Javascript'
      expect(response).to render_template :index
    end

    it 'should assign all articles to @articles' do
      expect(Article).to receive(:order).and_return(@articles)
      get :index
      expect(assigns(:articles)).to eq @articles
    end

    it 'should be able to filter by tags' do
      expect(Article).to receive(:tagged_with).with('Ruby')
      Article.stub_chain("tagged_with.order").and_return(@ruby_rails_articles)
      get :index, tag: 'Ruby'
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
      get :show, id: @article.friendly_id
      expect(response).to render_template :show
    end

    it 'should search the database using the friendly id' do
      dummy = Object.new
      expect(Article).to receive(:friendly).and_return(dummy)
      expect(dummy).to receive(:find).with(@article.friendly_id).and_return(@article)
      get :show, id: @article.friendly_id
    end

    it 'should assign the requested article to @article' do
      get :show, id: @article.friendly_id
      expect(assigns(:article)).to eq @article
    end

    it 'should assign the requested article author to @author' do
      get :show, id: @article.friendly_id
      expect(assigns(:author)).to eq @author
    end
  end

  describe 'GET new' do
    before(:each) { controller.stub(:authenticate_user!).and_return(true) }

    it 'should require authentication' do
      expect(controller).to receive(:authenticate_user!)
      get :new
    end

    it 'should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should assign a new article to @article' do
      get :new
      expect(assigns(:article)).to be_a(Article)
      expect(assigns(:article)).to be_new_record
    end

    it 'should be initialize the article with default tags if present' do
      tag = 'I love AV!'
      dummy = double('Article')
      expect(Article).to receive(:new).and_return(dummy)
      expect(dummy).to receive(:tag_list=).with([ tag ])
      get :new, tag: tag
    end
  end

  describe 'GET edit' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', friendly_id: 'friend')
      Article.stub_chain('friendly.find').and_return(@article)
    end

    it 'should require authentication' do
      expect(controller).to receive(:authenticate_user!)
      get :edit, id: @article.friendly_id
    end

    it 'should search for the article using friendly ids' do
      dummy = Object.new
      expect(Article).to receive(:friendly).and_return(dummy)
      expect(dummy).to receive(:find).with(@article.friendly_id)
      get :edit, id: @article.friendly_id
    end

    it 'should assign the article to be edited to @article' do
      get :edit, id: @article.friendly_id
      expect(assigns(:article)).to eq @article
    end
  end

  describe 'POST create' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = build(:article, title: 'my title', slug: 'friend')
      @user = double('User')
      allow(controller).to receive(:current_user).and_return(@user)
      allow(@article).to receive(:create_activity)
      @user.stub_chain('articles.build').and_return(@article)
    end

    it 'should require authentication' do
      expect(controller).to receive(:authenticate_user!)
      post :create, valid_params
    end

    it 'should create the article through the current user' do
      expect(controller).to receive(:current_user)
      dummy = Object.new
      expect(@user).to receive(:articles).and_return(dummy)
      expect(dummy).to receive(:build).and_return(@article)
      post :create, valid_params
    end

    it 'should be successful for requests with valid params' do
      post :create, valid_params
      expect(flash[:notice]).to match /^Successfully created the article/
      # Bryan: assumes title is equal to the friendly id
      expect(response).to redirect_to article_path(@article)
    end

    it 'should receive :create_activity with :create' do
      post :create, valid_params
      expect(@article).to have_received(:create_activity).with(:create, {owner: @user})
    end

    it 'should render the new template with error messages if unsuccessful' do
      expect(@article).to receive(:save).and_return(false)
      error_message = 'error!'
      @article.stub_chain('errors.full_messages.join').and_return(error_message)
      post :create, valid_params
      expect(flash.now[:alert]).to eq error_message
      expect(response).to render_template :new
    end
  end

  describe 'POST update' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', title: 'my title', friendly_id: 'friend')
      @article.stub(:update_attributes).and_return(true)
      Article.stub_chain('friendly.find').and_return(@article)
      allow(@article).to receive(:create_activity)
    end

    let (:valid_update_params) { valid_params.merge(id: @article.friendly_id) }

    it 'should require authentication' do
      expect(controller).to receive(:authenticate_user!)
      post :update, valid_update_params
    end

    it 'should receive :create_activity with :update' do
      post :update, valid_update_params
      expect(@article).to have_received(:create_activity).with(:update, {owner: @user})
    end

    it 'should redirect the user back to the show page with a flash message on success' do
      post :update, valid_update_params
      expect(flash[:notice]).to match /^Successfully updated the article/
      expect(response).to redirect_to article_path(@article)
    end

    it 'should render the edit template with error messages on failure' do
      error_messages = 'error!'
      expect(@article).to receive(:update_attributes).and_return(false)
      @article.stub_chain('errors.full_messages.join').and_return(error_messages)
      post :update, valid_update_params
      expect(flash.now[:alert]).to eq error_messages
      expect(response).to render_template :edit
    end
  end

  describe 'POST/PATCH preview' do
    before(:each) do
      @params = { article: { title: 'Patch title', content: 'Some content', tag_list: 'Ruby'}}
      controller.stub(:authenticate_user!).and_return(true)
    end

    it 'should require authentication' do
      expect(controller).to receive(:authenticate_user!)
      patch :preview, @params
    end

    it 'should render the preview template' do
      patch :preview, @params
      expect(response).to render_template :preview
    end

    it 'should assign a new article with the given parameters' do
      patch :preview, @params
      expect(assigns(:article)).to be_a(Article)
     
      @params[:article].each_pair do |k, v|
          expect(assigns(:article).send(k).to_s).to eq v
      end
    end

    it 'should assign default parameters to the preview article' do
      @user = double('User')
      controller.stub(:current_user).and_return(@user)
      patch :preview, @params
      assigns(:author).should eq @user
      expect(assigns(:article).created_at).to_not be_nil
      expect(assigns(:article).created_at).to_not be_nil
    end
  end
end

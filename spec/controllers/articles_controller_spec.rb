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
      response.should render_template :index
      get :index, tag: 'Javascript'
      response.should render_template :index
    end

    it 'should assign all articles to @articles' do
      Article.should_receive(:order).and_return(@articles)
      get :index
      assigns(:articles).should eq @articles
    end

    it 'should be able to filter by tags' do
      Article.should_receive(:tagged_with).with('Ruby')
      Article.stub_chain(:tagged_with, :order).and_return(@ruby_rails_articles)
      get :index, tag: 'Ruby'
      assigns(:articles).should eq @ruby_rails_articles
    end
  end

  describe 'GET show' do
    before(:each) do
      @author = double('User')
      @article = double('Article', friendly_id: 'friend', user: @author)
      Article.stub_chain(:friendly, :find).and_return(@article)
    end

    it 'should render the show template' do
      get :show, id: @article.friendly_id
      response.should render_template :show
    end

    it 'should search the database using the friendly id' do
      dummy = Object.new
      Article.should_receive(:friendly).and_return(dummy)
      dummy.should_receive(:find).with(@article.friendly_id).and_return(@article)
      get :show, id: @article.friendly_id
    end

    it 'should assign the requested article to @article' do
      get :show, id: @article.friendly_id
      assigns(:article).should eq @article
    end

    it 'should assign the requested article author to @author' do
      get :show, id: @article.friendly_id
      assigns(:author).should eq @author
    end
  end

  describe 'GET new' do
    before(:each) { controller.stub(:authenticate_user!).and_return(true) }

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      get :new
    end

    it 'should render the new template' do
      get :new
      response.should render_template :new
    end

    it 'should assign a new article to @article' do
      get :new
      assigns(:article).should be_a(Article)
      assigns(:article).should be_new_record
    end

    it 'should be initialize the article with default tags if present' do
      tag = 'I love AV!'
      dummy = double('Article')
      Article.should_receive(:new).and_return(dummy)
      dummy.should_receive(:tag_list=).with([ tag ])
      get :new, tag: tag
    end
  end

  describe 'GET edit' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', friendly_id: 'friend')
      Article.stub_chain(:friendly, :find).and_return(@article)
    end

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      get :edit, id: @article.friendly_id
    end

    it 'should search for the article using friendly ids' do
      dummy = Object.new
      Article.should_receive(:friendly).and_return(dummy)
      dummy.should_receive(:find).with(@article.friendly_id)
      get :edit, id: @article.friendly_id
    end

    it 'should assign the article to be edited to @article' do
      get :edit, id: @article.friendly_id
      assigns(:article).should eq @article
    end
  end

  describe 'POST create' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', save: true, title: 'my title', friendly_id: 'friend')
      @user = double('User')
      controller.stub(:current_user).and_return @user
      @user.stub_chain(:articles, :build).and_return(@article)
    end

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      post :create, valid_params
    end

    it 'should create the article through the current user' do
      controller.should_receive(:current_user)
      dummy = Object.new
      @user.should_receive(:articles).and_return(dummy)
      dummy.should_receive(:build).and_return(@article)
      post :create, valid_params
    end

    it 'should be successful for requests with valid params' do
      post :create, valid_params
      flash[:notice].should match /^Successfully created the article/
      # Bryan: assumes title is equal to the friendly id
      response.should redirect_to article_path(@article)
    end

    it 'should render the new template with error messages if unsuccessful' do
      @article.should_receive(:save).and_return(false)
      error_message = 'error!'
      @article.stub_chain(:errors, :full_messages, :join).and_return(error_message)
      post :create, valid_params
      flash.now[:alert].should eq error_message
      response.should render_template :new
    end
  end

  describe 'POST update' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', title: 'my title', friendly_id: 'friend')
      @article.stub(:update_attributes).and_return(true)
      Article.stub_chain(:friendly, :find).and_return(@article)
    end

    let (:valid_update_params) { valid_params.merge(id: @article.friendly_id) }

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      post :update, valid_update_params
    end

    it 'should redirect the user back to the show page with a flash message on success' do
      post :update, valid_update_params
      flash[:notice].should match /^Successfully updated the article/
      response.should redirect_to article_path(@article)
    end

    it 'should render the edit template with error messages on failure' do
      error_messages = 'error!'
      @article.should_receive(:update_attributes).and_return(false)
      @article.stub_chain(:errors, :full_messages, :join).and_return(error_messages)
      post :update, valid_update_params
      flash.now[:alert].should eq error_messages
      response.should render_template :edit
    end
  end

  describe 'POST/PATCH preview' do
    before(:each) do
      @params = { article: { title: 'Patch title', content: 'Some content', tag_list: 'Ruby'}}
      controller.stub(:authenticate_user!).and_return(true)
    end

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      patch :preview, @params
    end

    it 'should render the preview template' do
      patch :preview, @params
      response.should render_template :preview
    end

    it 'should assign a new article with the given parameters' do
      patch :preview, @params
      assigns(:article).should be_a(Article)
      @params[:article].each_pair do |k, v|
        # calls the method "k"
        if k == :tag_list
          assigns(:article).send(k).should eq [ v ]
        else
          assigns(:article).send(k).should eq v
        end
      end
    end

    it 'should assign default parameters to the preview article' do
      @user = double('User')
      controller.stub(:current_user).and_return(@user)
      patch :preview, @params
      assigns(:author).should eq @user
      assigns(:article).send(:created_at).should_not be_nil
      assigns(:article).send(:updated_at).should_not be_nil
    end
  end
end

# frozen_string_literal: true

RSpec.describe ArticlesController do
  let(:valid_params) do
    { article: { title: 'title',
                 content: 'Content',
                 tag_list: 'Ruby on Rails' } }
  end
  let(:articles) { instance_double(ActiveRecord::Relation) }

  describe 'GET index' do
    before { allow(articles).to receive_messages(order: articles, includes: articles) }

    context 'when tag is provided' do
      before { allow(Article).to receive(:tagged_with).and_return articles }

      it 'executes tagged queries', :aggregate_failures do
        get :index, params: { tag: 'tag' }
        expect(Article).to have_received(:tagged_with).with 'tag'
        expect(articles).to have_received(:order).with 'created_at DESC'
        expect(articles).to have_received(:includes).with :user
      end
    end

    context 'when tag is not provided' do
      before { allow(Article).to receive(:order).and_return articles }

      it 'executes untagged queries', :aggregate_failures do
        get :index
        expect(Article).to have_received(:order).with 'created_at DESC'
        expect(articles).to have_received(:includes).with :user
      end
    end
  end

  describe 'GET show' do
    let(:article) { double('Article', friendly_id: 'friend', user: author) }
    let(:author)  { double('User') }

    before(:each) do
      allow(Article).to receive(:friendly).and_return articles
      allow(articles).to receive(:find).and_return article
    end

    it 'is expected to render the show template' do
      get :show, params: { id: article.friendly_id }
      expect(response).to render_template :show
    end

    it 'is expected to search the database using the friendly id' do
      get :show, params: { id: article.friendly_id }
      expect(Article).to have_received(:friendly)
      expect(articles).to have_received(:find).with article.friendly_id
      expect(article).to have_received(:user)
    end

    it 'is expected to assign the requested article to article' do
      get :show, params: { id: article.friendly_id }
      expect(assigns(:article)).to eq article
    end

    it 'is expected to assign the requested article author to author' do
      get :show, params: { id: article.friendly_id }
      expect(assigns(:author)).to eq author
    end
  end

  describe 'GET new' do
    before(:each) { controller.stub(:authenticate_user!).and_return(true) }

    it 'is expected to require authentication' do
      expect(controller).to receive(:authenticate_user!)
      get :new
    end

    it 'is expected to render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'is expected to assign a new article to @article' do
      get :new
      expect(assigns(:article)).to be_a(Article)
      expect(assigns(:article)).to be_new_record
    end

    it 'should be initialize the article with default tags if present' do
      tag = 'I love AV!'
      dummy = double('Article')
      expect(Article).to receive(:new).and_return(dummy)
      expect(dummy).to receive(:tag_list=).with([tag])
      get :new, params: { tag: tag }
    end
  end

  describe 'GET edit' do
    let(:article) { double('Article', friendly_id: 'friend') }

    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      allow(Article).to receive(:friendly).and_return articles
      allow(articles).to receive(:find).and_return article
    end

    it 'is expected to require authentication' do
      expect(controller).to receive(:authenticate_user!)
      get :edit, params: { id: article.friendly_id }
    end

    it 'is expected to search for the article using friendly ids' do
      get :edit, params: { id: article.friendly_id }
      expect(Article).to have_received(:friendly)
      expect(articles).to have_received(:find).with article.friendly_id
    end

    it 'is expected to assign the article to be edited to article' do
      get :edit, params: { id: article.friendly_id }
      expect(assigns(:article)).to eq article
    end
  end

  describe 'POST create' do
    let(:user)    { double('User', id: 1) }
    let(:article) { build(:article, title: 'my title', slug: 'friend') }
    let(:save)    { true }

    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow(article).to receive(:create_activity)
      allow(user).to receive_message_chain(:articles, :build).and_return article
      allow(article).to receive(:save).and_return save
    end

    it 'is expected to require authentication' do
      expect(controller).to receive(:authenticate_user!)
      post :create, params: valid_params
    end

    context 'when successful' do
      before { allow(article).to receive(:create_activity) }

      it 'creates activity' do
        post :create, params: valid_params
        expect(article).to have_received(:create_activity).with(:create, { owner: user })
      end

      it 'is responds with success message', :aggregate_failures do
        post :create, params: valid_params
        expect(flash[:notice]).to match /^Successfully created the article/
        expect(response).to redirect_to article_path(article)
      end
    end

    context 'when unsuccessful' do
      let(:save)          { false }
      let(:error_message) { 'invalid form entry' }

      before do
        allow(article).to(
          receive_message_chain(:errors, :full_messages, :join).and_return(error_message)
        )
      end

      it 'responds with error message' do
        post :create, params: valid_params
        expect(flash.now[:alert]).to eq error_message
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST update' do
    before(:each) do
      controller.stub(:authenticate_user!).and_return(true)
      @article = double('Article', title: 'my title', friendly_id: 'friend')
      @article.stub(:update).and_return(true)
      Article.stub_chain('friendly.find').and_return(@article)
      allow(@article).to receive(:create_activity)
    end

    let(:valid_update_params) { valid_params.merge(id: @article.friendly_id) }

    it 'is expected to require authentication' do
      expect(controller).to receive(:authenticate_user!)
      post :update, params: valid_update_params
    end

    it 'is expected to receive :create_activity with :update' do
      post :update, params: valid_update_params
      expect(@article).to have_received(:create_activity).with(:update, { owner: @user })
    end

    it 'is expected to redirect the user back to the show page with a flash message on success' do
      post :update, params: valid_update_params
      expect(flash[:notice]).to match /^Successfully updated the article/
      expect(response).to redirect_to article_path(@article)
    end

    it 'is expected to render the edit template with error messages on failure' do
      error_messages = 'error!'
      expect(@article).to receive(:update).and_return(false)
      @article.stub_chain('errors.full_messages.join').and_return(error_messages)
      post :update, params: valid_update_params
      expect(flash.now[:alert]).to eq error_messages
      expect(response).to render_template :edit
    end
  end

  describe 'POST/PATCH preview' do
    before(:each) do
      @params = { article: { title: 'Patch title', content: 'Some content', tag_list: 'Ruby' } }
      controller.stub(:authenticate_user!).and_return(true)
    end

    it 'is expected to require authentication' do
      expect(controller).to receive(:authenticate_user!)
      patch :preview, params: @params
    end

    it 'is expected to render the preview template' do
      patch :preview, params: @params
      expect(response).to render_template :preview
    end

    it 'is expected to assign a new article with the given parameters' do
      patch :preview, params: @params
      expect(assigns(:article)).to be_a(Article)

      @params[:article].each_pair do |k, v|
        expect(assigns(:article).send(k).to_s).to eq v
      end
    end

    it 'is expected to assign default parameters to the preview article' do
      @user = double('User', id: 1)
      controller.stub(:current_user).and_return(@user)
      patch :preview, params: @params
      expect(assigns(:author)).to eq @user
      expect(assigns(:article).created_at).to_not be_nil
      expect(assigns(:article).created_at).to_not be_nil
    end
  end
end

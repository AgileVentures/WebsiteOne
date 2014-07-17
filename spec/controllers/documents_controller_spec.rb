require 'spec_helper'

describe DocumentsController do
  let(:user) { @user }
  let(:document) { @document }

  let(:valid_session) { {} }
  let(:valid_attributes) do 
    { 'title' => 'MyString',
    'body' => 'MyText',
    'user_id' => "#{user.id}" }
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
    @document = FactoryGirl.create(:document)
  end

  it 'should raise an error if no project was found' do
    expect {
      get :show, { id: @document.id, project_id: @document.project.id + 3 }, valid_session
    }.to raise_error ActiveRecord::RecordNotFound
  end

  describe 'GET show', type: :controller do

    context 'with a single project' do
      before(:each) do
        get :show, {:id => document.to_param, project_id: document.project.friendly_id}, valid_session
      end

      it 'assigns the requested document as @document' do
        assigns(:document).should eq(document)
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
    end

    context 'with more than one project' do
      before(:each) do
        @document_2 = FactoryGirl.create(:document)
      end

      it 'should not mistakenly render the document under the wrong project' do
        expect {
          get :show, { id: document.to_param, project_id: @document_2.project.friendly_id }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET new', type: :controller do
    before(:each) { get :new, {project_id: document.project.friendly_id}, valid_session }

    it 'assigns a new document as @document' do
      assigns(:document).should be_a_new(Document)
    end

    it 'renders the new template' do
      expect(response).to render_template 'new'
    end
  end

  describe 'POST create', type: :controller do
    describe 'with valid params' do
      it 'creates a new Document' do
        expect {
          post :create, {project_id: document.project.friendly_id, :document => valid_attributes}
        }.to change(Document, :count).by 1
      end

      it 'assigns a newly created document as @document' do
        post :create, {project_id: document.project.friendly_id, :document => valid_attributes}, valid_session
        assigns(:document).should be_a(Document)
        assigns(:document).should be_persisted
      end

      it 'redirects to the created document' do
        post :create, {project_id: document.project.friendly_id, :document => valid_attributes}, valid_session
        expect(response).to redirect_to project_document_path(Document.last.project, Document.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved document as @document' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {project_id: document.project.friendly_id, :document => { title: 'invalid value' }}, valid_session
        assigns(:document).should be_a_new(Document)
        assigns(:document).should_not be_persisted
      end

      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {project_id: document.project.friendly_id, :document => { title: 'invalid value' }}, valid_session
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'DELETE destroy', type: :controller do
    before(:each) { @document = FactoryGirl.create(:document) }

    it 'destroys the requested document' do
      expect {
        delete :destroy, {:id => @document.to_param, project_id: @document.project.friendly_id}, valid_session
      }.to change(Document, :count).by(-1)
    end

    it 'redirects to the documents list' do
      id = @document.project.id
      delete :destroy, {:id => @document.to_param, project_id: @document.project.friendly_id}, valid_session
      response.should redirect_to(project_documents_path(id))
    end
  end

  describe '#mercury_update', type: :controller do
    before do
      @params = {"document_title"=>
                      {"type"=>"simple", "value"=>"Title"},
                    "document_body_html"=>
                      {"type"=>"full", "value"=>"Html"},
                    "document_body_md"=>
                      {"type"=>"markdown", "value"=>"Markdown"} }
    end

    context 'document format is Markdown' do
      it 'updates attributes' do
        @document = FactoryGirl.create(:document, format: 'markdown')
        expect_any_instance_of(Document).
              to receive(:update!).
              with(hash_including(body: 'Markdown')).and_return(true)

        post :mercury_update, {project_id: @document.project.friendly_id,
                               document_id: @document.id,
                               content: @params }, valid_session
      end
    end

    context 'document format is not Markdown' do
      it 'updates attributes' do
        @document = FactoryGirl.create(:document, format: '')
        expect_any_instance_of(Document).
              to receive(:update!).
              with(hash_including(body: 'Html')).and_return(true)

        post :mercury_update, {project_id: @document.project.friendly_id,
                               document_id: @document.id,
                               content: @params }, valid_session
      end
    end
  end
end

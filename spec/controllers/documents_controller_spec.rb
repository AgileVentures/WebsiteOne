require 'spec_helper'

describe DocumentsController do
  let(:user) { @user }
  let(:document) { @document }
  let(:valid_attributes) { {
      'title' => 'MyString',
      'body' => 'MyText',
      'user_id' => "#{user.id}"
  } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
    @document = FactoryGirl.create(:document)
  end

  # Bryan: Deprecated path
  #describe 'GET index' do
  #  before(:each) { get :index, { project_id: document.friendly_id }, valid_session }
  #
  #  it 'assigns all documents as @documents' do
  #    assigns(:documents).should eq([document])
  #  end
  #
  #  it 'renders the index template' do
  #    expect(response).to render_template 'index'
  #  end
  #end

  describe 'GET show' do
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

  describe 'GET new' do
    before(:each) { get :new, {project_id: document.project.friendly_id}, valid_session }

    it 'assigns a new document as @document' do
      assigns(:document).should be_a_new(Document)
    end

    it 'renders the new template' do
      expect(response).to render_template 'new'
    end
  end

  describe 'GET edit' do
    before(:each) do
      get :edit, {:id => document.to_param, project_id: document.project.friendly_id}, valid_session
    end

    it 'assigns the requested document as @document' do
      assigns(:document).should eq(document)
    end

    it 'renders the edit template' do
      expect(response).to render_template 'edit'
    end
  end

  describe 'POST create' do
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

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested document' do
        Document.any_instance.should_receive(:update).with(valid_attributes)
        put :update, {id: document.to_param, project_id: document.project.friendly_id, document: valid_attributes}, valid_session
      end

      it 'assigns the requested document as @document' do
        put :update, {id: document.to_param, project_id: document.project.friendly_id, document: valid_attributes}, valid_session
        assigns(:document).should eq(document)
      end

      it 'redirects to the document' do
        put :update, {id: document.to_param, project_id: document.project.friendly_id, document: valid_attributes}, valid_session
        response.should redirect_to project_document_path(Document.last.project, Document.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns the document as @document' do
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, project_id: document.project.friendly_id, :document => { title: 'invalid value' }}, valid_session
        assigns(:document).should eq(document)
      end

      it 're-renders the edit template' do
        #document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, project_id: document.project.friendly_id, :document => { title: 'invalid value' }}, valid_session
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'DELETE destroy' do
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
end

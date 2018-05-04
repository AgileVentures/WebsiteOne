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
  let(:categories) do 
    [
    FactoryBot.create(:document, id: 555, project_id: document.project_id, parent_id: nil, title: "Title-1"),
    FactoryBot.create(:document, id: 556, project_id: document.project_id, parent_id: nil, title: "Title-2")
    ]
  end
  let(:params) { {:id => categories.first.to_param, project_id: document.project.friendly_id, categories: 'true'} }

  before(:each) do
    @user = FactoryBot.create(:user)
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
    @document = FactoryBot.create(:document)
    allow(@document).to receive(:create_activity)
  end

  it 'should raise an error if no project was found' do
    expect {
      get :show, params: { id: @document.id, project_id: @document.project.id + 3 }.merge(valid_session)
    }.to raise_error ActiveRecord::RecordNotFound
  end

  describe 'GET show' do

    context 'with a single project' do
      before(:each) do
        get :show, params: {:id => document.to_param, project_id: document.project.friendly_id}.merge(valid_session)
      end

      it 'assigns the requested document as @document' do
        expect(assigns(:document)).to eq(document)
      end

      it 'renders the show template' do
        expect(response).to render_template 'show'
      end
    end

    context 'with more than one project' do
      before(:each) do
        @document_2 = FactoryBot.create(:document)
      end

      it 'should not mistakenly render the document under the wrong project' do
        expect {
          get :show, params: { id: document.to_param, project_id: @document_2.project.friendly_id }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'get_doc_categories' do
    context 'it has categories to show' do
      it 'renders the categories partial' do
        get :get_doc_categories, params: params
        expect(response).to render_template(:partial => '_categories')
      end

      it 'assigns the available categories to @categories' do
        get :get_doc_categories, params: params.merge({id: document.to_param})
        extended_categories = categories.push(document)
        expect(assigns(:categories)).to  match_array extended_categories
      end
    end
  end

  describe 'PUT update_document_parent_id/' do
    let(:do_post) { post :update_parent_id, params: params.merge({ new_parent_id: parent_id }) }
    let(:current_document) { Document.find_by_id(categories.first.id) }

    context 'with a valid parent id' do
      let(:parent) { Document.find_by_id(categories.last.id) }
      let(:parent_id) { parent.id.to_s }

      it 'changes the document parent id' do
        do_post
        expect(current_document.parent_id).to eq(parent.id)
      end

      it 'assigns flash message after changing parent_id' do
        do_post
        expect(flash[:notice]).to eq('You have successfully moved Title-1 to the Title-2 section.')
      end
    end

    context 'with an invalid parent id' do
      let(:parent_id) { 'invalid_id' }

      it 'does not change the document parent id' do
        old_parent_id = current_document.parent_id
        do_post
        current_document.reload
        expect(current_document.parent_id).to eq(old_parent_id)
      end

      it 'renders a flash error message' do
        do_post
        expect(flash[:error]).to eq('Could not find the new parent document')
      end
    end
  end

  describe 'GET new' do
    before(:each) { get :new, params: { project_id: document.project.friendly_id}.merge(valid_session) }

    it 'assigns a new document as @document' do
      expect(assigns(:document)).to be_a_new(Document)
    end

    it 'renders the new template' do
      expect(response).to render_template 'new'
    end

  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Document' do
        expect {
          post :create, params: { project_id: document.project.friendly_id, document: valid_attributes }
        }.to change(Document, :count).by 1
      end

      it 'assigns a newly created document as @document' do
        post :create, params: {project_id: document.project.friendly_id, document: valid_attributes}.merge(valid_session)
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it 'redirects to the created document' do
        post :create, params: { project_id: document.project.friendly_id, document: valid_attributes }.merge(valid_session)
        expect(response).to redirect_to project_document_path(Document.last.project, Document.last)
      end

      it 'creates a document create activity' do
        expect {
          post :create, params: { project_id: document.project.friendly_id, document: valid_attributes }
        }.to change(PublicActivity::Activity, :count).by 1
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved document as @document' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, params: { project_id: document.project.friendly_id, document: { title: 'invalid value' } }.merge(valid_session)
        expect(assigns(:document)).to be_a_new(Document)
        expect(assigns(:document)).to_not be_persisted
      end

      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, params: { project_id: document.project.friendly_id, document: { title: 'invalid value' } }.merge(valid_session)
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) { @document = FactoryBot.create(:document) }

    it 'destroys the requested document' do
      expect {
        delete :destroy, params: { id: @document.to_param, project_id: @document.project.friendly_id }.merge(valid_session)
      }.to change(Document, :count).by(-1)
    end

    it 'redirects to the documents list' do
      id = @document.project.id
      delete :destroy, params: {id: @document.to_param, project_id: @document.project.friendly_id }.merge(valid_session)
      expect(response).to redirect_to(project_documents_path(id))
    end
  end
end

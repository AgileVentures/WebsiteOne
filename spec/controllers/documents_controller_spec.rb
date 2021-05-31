# frozen_string_literal: true

RSpec.describe DocumentsController, type: :controller do
  let(:user) { @user }
  let(:document) { @document }
  let(:valid_attributes) do
    {
      'title' => 'MyString',
      'body' => 'MyText',
      'user_id' => user.id.to_s
    }
  end
  let(:valid_session) { {} }
  let(:categories) do
    [
      create(:document, id: 555, project_id: document.project_id, parent_id: nil, title: 'Title-1'),
      create(:document, id: 556, project_id: document.project_id, parent_id: nil, title: 'Title-2')
    ]
  end
  let(:params) { { id: categories.first.to_param, project_id: document.project.friendly_id, categories: 'true' } }

  before(:each) do
    @user = create(:user)
    request.env['warden'].stub authenticate!: user
    controller.stub current_user: user
    @document = create(:document, title: 'doc title')
    allow(@document).to receive(:create_activity)
  end

  it 'is expected to raise an error if no project was found' do
    expect do
      get :show, params: { id: @document.id, project_id: @document.project.id + 3 }.merge(valid_session)
    end.to raise_error ActiveRecord::RecordNotFound
  end

  describe 'GET show' do
    context 'with a single project' do
      before(:each) do
        get :show, params: { id: document.to_param, project_id: document.project.friendly_id }.merge(valid_session)
      end

      it 'is expected to assign the requested document as @document' do
        expect(assigns(:document)).to eq(document)
      end

      it do
        expect(response).to render_template 'show'
      end
    end

    context 'with more than one project' do
      before(:each) do
        @document_2 = create(:document)
      end

      it 'is expected to not mistakenly render the document under the wrong project' do
        expect do
          get :show, params: { id: document.to_param, project_id: @document_2.project.friendly_id }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'get_doc_categories' do
    context 'has categories to show' do
      it 'is expected to render the categories partial' do
        get :get_doc_categories, params: params
        expect(response).to render_template(partial: '_categories')
      end

      it 'is expected to assign the available categories to @categories' do
        get :get_doc_categories, params: params.merge({ id: document.to_param })
        extended_categories = categories.push(document)
        expect(assigns(:categories)).to match_array extended_categories
      end
    end
  end

  describe 'PUT update_document_parent_id/' do
    let(:do_post) { post :update_parent_id, params: params.merge({ new_parent_id: parent_id }) }
    let(:current_document) { Document.find_by_id(categories.first.id) }

    context 'with a valid parent id' do
      let(:parent) { Document.find_by_id(categories.last.id) }
      let(:parent_id) { parent.id.to_s }

      it 'is expected to change the document parent id' do
        do_post
        expect(current_document.parent_id).to eq(parent.id)
      end

      it 'is expected to assign flash message after changing parent_id' do
        do_post
        expect(flash[:notice]).to eq('You have successfully moved Title-1 to the Title-2 section.')
      end
    end

    context 'with an invalid parent id' do
      let(:parent_id) { 'invalid_id' }

      it 'is not expected to change the document parent id' do
        old_parent_id = current_document.parent_id
        do_post
        current_document.reload
        expect(current_document.parent_id).to eq(old_parent_id)
      end

      it 'is expected to render a flash error message' do
        do_post
        expect(flash[:error]).to eq('Could not find the new parent document')
      end
    end
  end

  describe 'GET new' do
    before(:each) { get :new, params: { project_id: document.project.friendly_id }.merge(valid_session) }

    it 'is expected to assign a new document as @document' do
      expect(assigns(:document)).to be_a_new(Document)
    end

    it do
      expect(response).to render_template 'new'
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'is expected to create a new Document' do
        expect do
          post :create, params: { project_id: document.project.friendly_id, document: valid_attributes }
        end.to change(Document, :count).by 1
      end

      it 'is expected to assign a newly created document as @document' do
        post :create,
             params: { project_id: document.project.friendly_id, document: valid_attributes }.merge(valid_session)
        expect(assigns(:document)).to be_a(Document)
        expect(assigns(:document)).to be_persisted
      end

      it 'is expected to redirect to the created document' do
        post :create,
             params: { project_id: document.project.friendly_id, document: valid_attributes }.merge(valid_session)
        expect(response).to redirect_to project_document_path(Document.last.project, Document.last)
      end

      it 'is expected to create a document create activity' do
        expect do
          post :create, params: { project_id: document.project.friendly_id, document: valid_attributes }
        end.to change(PublicActivity::Activity, :count).by 1
      end
    end

    describe 'with invalid params' do
      it 'is expected to assign a newly created but unsaved document as @document' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create,
             params: { project_id: document.project.friendly_id,
                       document: { title: 'invalid value' } }.merge(valid_session)
        expect(assigns(:document)).to be_a_new(Document)
        expect(assigns(:document)).to_not be_persisted
      end

      it 'is expected to re-render the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create,
             params: { project_id: document.project.friendly_id,
                       document: { title: 'invalid value' } }.merge(valid_session)
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) { @document = FactoryBot.create(:document) }

    it 'is expected to destroy the requested document' do
      expect do
        delete :destroy,
               params: { id: @document.to_param, project_id: @document.project.friendly_id }.merge(valid_session)
      end.to change(Document, :count).by(-1)
    end

    it 'is expected to redirect to the documents list' do
      id = @document.project.id
      delete :destroy,
             params: { id: @document.to_param, project_id: @document.project.friendly_id }.merge(valid_session)
      expect(response).to redirect_to(project_documents_path(id))
    end
  end

  describe 'POST mercury_update' do
    before(:each) do
      Document.stub_chain(:friendly, :find)
              .with(@document.friendly_id).and_return(document)
    end

    context 'with valid params' do
      let(:params) do
        {
          project_id: @document.project.friendly_id,
          document_id: @document.friendly_id,
          content: {
            document_title: { value: 'my title' },
            document_body: { value: 'document body' }
          }
        }
      end

      before(:each) do
        allow(document).to receive(:create_activity)
        allow(document).to receive(:update)
          .and_return(true)
      end

      it 'is expected to render an empty string' do
        put :mercury_update, params: params
        expect(response.body).to be_empty
      end

      it 'is expected to update the document with the new title and body' do
        put :mercury_update, params: params
        expect(document).to have_received(:update)
          .with({ title: 'my title', body: 'document body' })
      end

      it 'is expected to create a document update activity' do
        put :mercury_update, params: params
        expect(document).to have_received(:create_activity)
          .with(:update, owner: user)
      end
    end
  end
end

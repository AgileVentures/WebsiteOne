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

  it 'should raise an error if no project was found' do
    expect {
      get :show, { id: @document.id, project_id: @document.project.id + 3 }, valid_session
    }.to raise_error ActiveRecord::RecordNotFound
  end

  describe 'GET index' do

    it 'redirects to project index page' do
      get :index, { project_id: document.project.id }, valid_session
      expect(response).to redirect_to project_path document.project
    end

  end

  describe 'GET show' do

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

  describe 'PUT mercury_update' do
    before(:each) do
      Document.stub_chain(:friendly, :find).and_return(@document)
    end

    it 'assigns the requested document as @document' do
      put :mercury_update, project_id: @document.project.slug, document_id: @document.slug, content: { document_title: { value: 'MyTitle' }, document_body: { value: 'MyBody' } }
      assigns(:document).should eq(@document)
    end

    context 'with valid params' do
      before(:each) do
        @document.should_receive(:update_attributes).with(title: 'MyTitle', body: 'MyBody').and_return true
        put :mercury_update, project_id: @document.project.slug, document_id: @document.slug, content: { document_title: { value: 'MyTitle' }, document_body: { value: 'MyBody' } }
      end

      it 'should render a blank string' do
        response.body.should be_empty
      end
    end

    context 'with invalid params' do
      before(:each) do
        @document.should_receive(:update_attributes).and_return false
        put :mercury_update, project_id: @document.project.slug, document_id: @document.slug, content: { document_title: { value: '' }, document_body: { value: '' } }
      end

      it 'should not render anything' do
        # render nothing actually renders a space
        response.body.should eq ' '
      end
    end
  end

  describe 'GET mercury_saved' do
    before(:each) do
      get :mercury_saved, project_id: @document.project.slug, document_id: @document.slug
    end

    it 'should redirect to the static_page_path' do
      response.should redirect_to project_document_path(@document.project, @document)
    end

    it 'should display a flash message "The document has been successfully updated."' do
      flash[:notice].should eq 'The document has been successfully updated.'
    end
  end

  # Private Methods

  describe '#set_parent' do
    before do
      controller = DocumentsController.new
    end
    it 'should set parent when parent_id is present' do
      controller.params[:parent_id] = @document.id
      controller.instance_eval{set_parent} # Calling Private Methods
      assigns(:parent).should eq @document
    end

    it 'should not set parent when parent_id is not present' do
      controller.instance_eval{ set_parent } # Calling Private Methods
      assigns(:parent).should eq nil
    end
  end
end

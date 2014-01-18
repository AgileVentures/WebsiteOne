require 'spec_helper'

describe DocumentsController do
  before(:each) do
    user = double('user')
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
  end

  let(:document) { FactoryGirl.create(:document) }
  let(:valid_attributes) { { title: "MyString", project_id: document.project_id} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DocumentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all documents as @documents" do
      #document = Document.create! valid_attributes
      get :index, { project_id: document.project_id }, valid_session
      assigns(:documents).should eq([document])
    end
  end

  describe "GET show" do
    it "assigns the requested document as @document" do
      #document = Document.create! valid_attributes
      get :show, {:id => document.to_param, project_id: document.project_id}, valid_session
      assigns(:document).should eq(document)
    end
  end

  describe "GET new" do
    it "assigns a new document as @document" do
      get :new, {project_id: document.project_id}, valid_session
      assigns(:document).should be_a_new(Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested document as @document" do
      #document = Document.create! valid_attributes
      get :edit, {:id => document.to_param, project_id: document.project_id}, valid_session
      assigns(:document).should eq(document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Document" do
        document # document is lazily loaded
        expect {
          post :create, {project_id: document.project_id, :document => valid_attributes}
        }.to change(Document, :count).by 1
      end

      it "assigns a newly created document as @document" do
        post :create, {project_id: document.project_id, :document => valid_attributes}, valid_session
        assigns(:document).should be_a(Document)
        assigns(:document).should be_persisted
      end

      it "redirects to the created document" do
        post :create, {project_id: document.project_id, :document => valid_attributes}, valid_session
        response.should redirect_to project_documents_path(project_id: Document.last.project_id)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved document as @document" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {project_id: document.project_id, :document => { "title" => "invalid value" }}, valid_session
        assigns(:document).should be_a_new(Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        post :create, {project_id: document.project_id, :document => { "title" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested document" do
        #document = Document.create! valid_attributes
        # Assuming there are no other documents in the database, this
        # specifies that the Document created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Document.any_instance.should_receive(:update).with({ "title" => "MyString" })
        put :update, {project_id: document.project_id, :id => document.to_param, :document => { "title" => "MyString" }}, valid_session
      end

      it "assigns the requested document as @document" do
        #document = Document.create! valid_attributes
        put :update, {:id => document.to_param, project_id: document.project_id, :document => valid_attributes}, valid_session
        assigns(:document).should eq(document)
      end

      it "redirects to the document" do
        #document = Document.create! valid_attributes
        put :update, {:id => document.to_param, project_id: document.project_id, :document => valid_attributes}, valid_session
        response.should redirect_to project_document_path(id: Document.last.id, project_id: Document.last.project_id)
      end
    end

    describe "with invalid params" do
      it "assigns the document as @document" do
        #document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, project_id: document.project_id, :document => { "title" => "invalid value" }}, valid_session
        assigns(:document).should eq(document)
      end

      it "re-renders the 'edit' template" do
        #document = Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, project_id: document.project_id, :document => { "title" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) { @document = FactoryGirl.create(:document) }


    it "destroys the requested document" do
      expect {
        delete :destroy, {:id => @document.to_param, project_id: @document.project_id}, valid_session
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      #document = Document.create! valid_attributes
      id = @document.project.id
      delete :destroy, {:id => @document.to_param, project_id: @document.project_id}, valid_session
      response.should redirect_to(project_documents_path(id))
    end
  end
end

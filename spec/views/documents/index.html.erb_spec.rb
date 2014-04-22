require 'spec_helper'
include MercuryHelper


describe 'documents/index' do
  before(:each) do
	@documents = [        
		stub_model(Document, :title => "Title",:body => "MyText", :project_id => 1 ),
    stub_model(Document, :title => "Title", :body => "MyText", :project_id => 2)
		 ]

    assign(:documents, @documents)
    @dummy_project = FactoryGirl.create(:project)
    assign(:project, @dummy_project)
    @project_id = @documents[0].project_id
  end
  context 'for signed in and not signed in users' do
    it 'renders a list of documents' do
      render
      rendered.should have_link('Title', :count => 2)
      rendered.should have_content('MyText', :count => 2)
    end
  end
  context 'for signed in users' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
 
    it 'should have edit button' do
      render
      rendered.should have_link 'Edit', :href => mercury_edit_path(project_document_path(id: @documents[0].id, project_id: @project_id))
    end

    it 'should render a New Document button' do
      render
      rendered.should have_link 'New Document', :href => new_project_document_path(project_id: @dummy_project.id)
    end

  end
  context 'for not signed in users' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end
	
    it 'should not have edit button if not signed in' do
      render
      rendered.should_not have_link 'Edit', :href => mercury_edit_path(project_document_path(id: @documents[0].id, project_id: @project_id))
    end

    it 'should not have edit button if not signed in' do
      render
      rendered.should_not have_link 'Destroy', :href => project_document_path(id: @documents[0].id, project_id: @project_id)
    end

  end
end

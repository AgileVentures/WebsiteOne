require 'spec_helper'

describe 'documents/new' do
  before(:each) do
    @project = stub_model(Project, :id => 1, friendly_id: 'project-1')
    @document = assign(:document, stub_model(Document,
      :id => 1,
      :title => 'MyString',
      :body => 'MyText',
      :project_id => 1
    ))
    @parent = mock_model(Document, title: 'My title') 
  end

  context 'user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(true)
    end
    it 'renders new document form' do
      render
      assert_select 'form[action=?][method=?]', project_document_path(@project, @document), 'post' do
        assert_select 'input#document_parent_id[name=?]', 'document[parent_id]'
        assert_select 'input#document_title[name=?]', 'document[title]'
        assert_select 'input#document_project_id[name=?]', 'document[project_id]'
      end
    end

    it 'renders a back button' do
      render
      expect(rendered).to have_link('Back', href: project_path(@project))
    end
  end
end

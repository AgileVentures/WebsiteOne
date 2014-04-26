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

    #it 'should render a New Document button' do   //existing code for the new doc in index for docs
    #  render
    #  rendered.should have_link 'New Document', :href => new_project_document_path(project_id: @dummy_project.id)
    #end

    #it 'renders correct icon for creating a new sub-document' do
    #  render
    #  #debugger
    #  rendered.should have_selector("#new_document_link") do |link|
    #    debugger
    #  link.should have_css('i[class="fa fa-file-text-o"]')
    #  #rendered.should have_selector(:css, "ul li#new_document_link")
    #
    #  end
    #  #rendered.within('ul#project-list') do |rendered_date|
    #
    #end

    #=scoping=
    #    within("//li[@id='employee']") do
    #      fill_in 'Name', :with => 'Jimmy'
    #    end
    #within(:css, "li#employee") do
    #  fill_in 'Name', :with => 'Jimmy'
    #end
    #within_fieldset('Employee') do
    #  fill_in 'Name', :with => 'Jimmy'
    #end
    #within_table('Employee') do
    #  fill_in 'Name', :with => 'Jimmy'
    #end

    #=XPath and CSS=
    #    within(:css, 'ul li') { ... }
    #find(:css, 'ul li').text
    #locate(:css, 'input#name').value
    #Capybara.default_selector = :css
    #within('ul li') { ... }
    #find('ul li').text
    #locate('input#name').value
    #rendered.should have_link 'New Sub-document', :href => new_project_document_path(project_id: @project.friendly_id, parent_id: @document.id), id: 'new_document_link'





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

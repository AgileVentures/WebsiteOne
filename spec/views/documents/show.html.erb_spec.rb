require 'spec_helper'

describe "documents/show" do
  before(:each) do
    @user = mock_model(User, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org')
    @project = assign(:project, stub_model(Project, :id => 1, :title => "Project1", :created_at => Time.now))
    @document = stub_model(Document,
                           :id => 1,
                           :title => "Title",
                           :body => "Content",
                           :project_id => 1 ,
                           :created_at => Time.now
    )

    @document_child = stub_model(Document,
                                 :title => "Child Title",
                                 :body => "Child content",
                                 :project_id => 1,
                                 :parent_id => 1,
                                 :created_at => Time.now
    )
    @document.stub(:children).and_return([ @document_child ])
    assign(:user, @user)
    view.stub(:created_by).and_return(@created_by)
  end
  #
  #it "renders attributes in <span>" do
  #  render
  #  rendered.should have_content('Title')
  #  rendered.should have_content('MyText')
  #end
  context 'document is root' do
    before do
      assign :document, @document
    end
    it 'render content and child of root document' do
      render
      rendered.should have_content "Title"
      rendered.should have_content "Content"
      rendered.should have_content "Child Title"
    end
  end

  context 'document is a child' do
    before do
      assign :document, @document_child
    end
    it 'render content of document' do
      render
      rendered.should have_content "Child Title"
      rendered.should have_content "Child content"
    end
  end
end

require 'spec_helper'

describe "documents/show" do
  before(:each) do
    @user = mock_model(User, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org', display_name: 'John Simpson')
    @project = assign(:project, stub_model(Project, :id => 1, :title => "Project1", :created_at => Time.now))
    @version = stub_model(PaperTrail::Version,
                          item_type: "Document",
                          event: "create",
                          whodunnit: @user.id,
                          object: nil,
                          created_at: "2014-02-25 11:50:56"
    )
    @document = stub_model(Document,
                           :user => @user,
                           :id => 1,
                           :title => "Title",
                           :body => "Content",
                           :project_id => 1 ,
                           :created_at => Time.now,
                           :versions => [@version]
    )

    @document_child = stub_model(Document,
                                 :user => @user,
                                 :title => "Child Title",
                                 :body => "Child content",
                                 :project_id => 1,
                                 :parent_id => 1,
                                 :created_at => Time.now,
                                 :versions => [@version]
    )

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
      assign :children, [ @document_child ]
      @document_child.should_receive(:user).and_return(@user)
    end

    it 'render content and child of root document' do
      render
      rendered.should have_content @document.title
      rendered.should have_content @document.body
      rendered.should have_content @document_child.title
    end

    it 'should not render document revisions history for new documents' do
      render
      rendered.should_not have_text 'Revisions'
    end

    it 'should render document revisions history for documents with more than 1 revision' do
      @document.stub(versions: [ @version, @version ])
      render
      rendered.should have_text 'Revisions'
    end
  end

  context 'document is a child' do
    before do
      assign :document, @document_child
      assign :children, []
    end

    it 'render content of document' do
      render
      rendered.should have_content @document_child.title
      rendered.should have_content @document_child.body
    end
  end
end

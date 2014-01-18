require 'spec_helper'

describe "documents/new" do
  before(:each) do
    @project = stub_model(Project, {:id => 1})
    @document = assign(:document, stub_model(Document,
      :id => 1,
      :title => "MyString",
      :body => "MyText",
      :project_id => 1
    ))
  end

  context 'user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(true)
    end
    it "renders new document form" do
      render

      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", project_document_path(@project, @document), "post" do
        assert_select "input#document_title[name=?]", "document[title]"
        assert_select "textarea#document_body[name=?]", "document[body]"
        assert_select "input#document_project_id[name=?]", "document[project_id]"
      end
    end
  end
end

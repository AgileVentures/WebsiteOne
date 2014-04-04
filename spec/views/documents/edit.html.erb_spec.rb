require 'spec_helper'

describe "documents/edit" do
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
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    it "renders the edit document form" do
      render

      assert_select "form[action=?][method=?]", project_document_path(@project, @document), "post" do
        assert_select "input#document_title[name=?]", "document[title]"
        assert_select "input#document_project_id[name=?]", "document[project_id]"
      end
    end
  end
end

require 'spec_helper'

describe "documents/edit" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :title => "MyString",
      :body => "MyText",
      :project_id => 1
    ))
  end

  it "renders the edit document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", document_path(@document), "post" do
      assert_select "input#document_title[name=?]", "document[title]"
      assert_select "textarea#document_body[name=?]", "document[body]"
      assert_select "input#document_project_id[name=?]", "document[project_id]"
    end
  end
end

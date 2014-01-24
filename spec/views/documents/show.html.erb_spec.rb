require 'spec_helper'

describe "documents/show" do
  before(:each) do
    #@document = FactoryGirl(:document)
    @document = assign(:document, stub_model(Document,
      :title => "Title",
      :body => "MyText",
      :project_id => 1
    ))
  end
  #
  #it "renders attributes in <span>" do
  #  render
  #  rendered.should have_content('Title')
  #  rendered.should have_content('MyText')
  #end
end

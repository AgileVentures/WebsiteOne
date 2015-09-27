require 'spec_helper'

describe "newsletters/edit" do
  before(:each) do
    @newsletter = assign(:newsletter, stub_model(Newsletter,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit newsletter form" do
    render

    assert_select "form[action=?][method=?]", newsletter_path(@newsletter), "post" do
      assert_select "input#newsletter_title[name=?]", "newsletter[title]"
      assert_select "textarea#newsletter_body[name=?]", "newsletter[body]"
    end
  end
end

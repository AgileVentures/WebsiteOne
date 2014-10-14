require 'spec_helper'

describe "newsletters/show" do
  before(:each) do
    @newsletter = assign(:newsletter, stub_model(Newsletter,
      :title => "Title",
      :subject=> "My Subject"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Title/)
    rendered.should match(/My Subject/)
  end
end

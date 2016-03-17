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
    expect(rendered).to match /Title/
    expect(rendered).to match /My Subject/
  end
end

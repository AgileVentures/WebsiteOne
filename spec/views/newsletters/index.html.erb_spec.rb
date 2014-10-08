require 'spec_helper'

describe "newsletters/index" do
  before(:each) do
    assign(:newsletters, [
      stub_model(Newsletter,
        :title => "Title",
        :subject => "My Subject",
        :was_sent => false,
      ),
      stub_model(Newsletter,
        :title => "Title",
        :subject => "My Subject",
        :was_sent => false,
      )
    ])
  end

  it "renders a list of newsletters" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "My Subject".to_s, :count => 2
  end
end

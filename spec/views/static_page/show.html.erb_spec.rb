require 'spec_helper'

describe "static_pages/show" do
  before(:each) do
    @user = mock_model(User, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org', display_name: 'John Simpson')
    @page = stub_model(StaticPage,
                       :id => 1,
                       :title => "Title",
                       :body => "Content",
                       :created_at => Time.now,
    )
  end

  before do
    assign :page, @page
  end
  it 'render page content' do
    render
    rendered.should have_content @page.title
    rendered.should have_content @page.body
  end
end

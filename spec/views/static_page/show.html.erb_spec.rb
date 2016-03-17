require 'spec_helper'

describe "static_pages/show" do
  before(:each) do
    @user = mock_model(User, id: 1, first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org', display_name: 'John Simpson')
    @version = stub_model(PaperTrail::Version,
                          item_type: "StaticPage",
                          event: "create",
                          whodunnit: @user.id,
                          object: nil,
                          created_at: "2014-02-25 11:50:56"
    )
    @page = stub_model(StaticPage,
                       :id => 1,
                       :title => "Title",
                       :body => "Content",
                       :created_at => Time.now,
    )
    @ancestry = [@page.title]

    assign :page, @page
    assign :ancestry, @ancestry

    @page.stub(:versions).and_return([@version])
  end

  it 'render page content' do
    render
    expect(rendered).to have_content @page.title
    expect(rendered).to have_content @page.body
  end

  it 'should not render page revisions history for new pages' do
    render
    expect(rendered).to_not have_content 'Revisions'
  end

  it 'should render page revisions history for pages with more than 1 revisions' do
    @page.stub(versions: [ @version, @version ])
    render
    expect(rendered).to have_content 'Revisions'
  end

  it 'renders correct ancestry for static page' do
    render
    rendered.within("#ancestry") do
      expect(rendered).to have_content "Agile Ventures"
      expect(rendered).to have_content @page.title
    end
  end
end

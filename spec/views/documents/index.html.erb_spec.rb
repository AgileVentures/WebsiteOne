require 'spec_helper'

describe 'documents/index' do
  before(:each) do
    assign(:documents, [
        stub_model(Document, :title => "Title",:body => "MyText", :project_id => 1 ),
        stub_model(Document, :title => "Title", :body => "MyText", :project_id => 2)
    ])
  end
  context 'for signed in and not signed in users' do
    it 'renders a list of documents' do
      render
      assert_select "tr>td", :text => "Title".to_s, :count => 2
      assert_select "tr>td", :text => "MyText".to_s, :count => 2
      assert_select "tr>td", :text => 1.to_s, :count => 1
      assert_select "tr>td", :text => 2.to_s, :count => 1
    end

    it 'should render column headers in table' do
      render
      rendered.should have_selector('th', :text => 'Title')
      rendered.should have_selector('th', :text => 'Body')
    end
  end
  context 'for signed in users' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    it 'should render a New Document button' do
      render
      rendered.should have_link('New Document', :href => new_document_path)
    end

  end
  context 'for not signed in users' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end


  end
end

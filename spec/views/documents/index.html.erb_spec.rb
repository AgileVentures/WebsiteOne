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
  end
  context 'for signed in users' do

  end
  context 'for not signed in users' do

  end
end

require 'spec_helper'

describe "scrums/index.html.erb"  do
  @documents = [
      stub_model(Document, :title => "Title",:body => "MyText", :project_id => 1 ),
      stub_model(Document, :title => "Title", :body => "MyText", :project_id => 2)
  ]

  assign(:documents, @documents)
  @dummy_project = FactoryGirl.create(:project)
  assign(:project, @dummy_project)
  @project_id = @documents[0].project_id
end

describe "scrums/index.html.erb"  do
  @scrums = [
      stub_model(Scrum, :author => "Author",:published => "Date", :content => "Content", :url => 'Url', :project_id => 1 ),
      stub_model(Scrum, :author => "Author",:published => "Date", :content => "Content", :url => 'Url', :project_id => 2 )
  ]

  assign(:scrums, @scrums)
  @project_id = @scrums[0].project_id
end

  #it 'should render/display a list of scrums by date in descending order' do
  #it 'should launch the modal window when I click "play" button'
  #it 'should play the video via modal window popup'
  #it 'should close modal window when I "x" video'




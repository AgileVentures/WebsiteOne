Given(/^The project has some stories on Pivotal Tracker$/) do
  @labels ||= File.read('spec/fixtures/project_pt_labels_response.json')
  @current ||= File.read('spec/fixtures/project_pt_current_response.json')
  @stories ||= File.read('spec/fixtures/project_pt_stories_response.json')
  stub_request(:get, /www\.pivotaltracker\..+\d+[^\/]*$/).
    to_return(status: 200, body: @labels, headers: {})
  stub_request(:get, /www\.pivotaltracker\..+\d+\/iterations[^\/]*$/).
    to_return(:status => 200, :body => @current, :headers => {})
  stub_request(:get, /www\.pivotaltracker\..+\d+\/stories[^\/]*$/).
    to_return(:status => 200, body: @stories, :headers =>  {})
end

Given(/The project has no stories on Pivotal Tracker/) do
  dummy = Object.new
  dummy.stub(stories: nil)
  PivotalService.stub(one_project: nil)
  PivotalService.stub(iterations: dummy)
end

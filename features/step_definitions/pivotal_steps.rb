Given(/^The project has some stories on Pivotal Tracker$/) do
  @current ||= File.read('spec/fixtures/pivotal_tracker_project_current_iteration.json')
  @project ||= File.read('spec/fixtures/pivotal_tracker_project_response.json')
  stub_request(:get, /www\.pivotaltracker\..+\d+[^\/]*$/).
    to_return(status: 200, body: @project, headers: {})
  stub_request(:get, /www\.pivotaltracker\..+\d+\/iterations[^\/]*$/).
    to_return(:status => 200, :body => @current, :headers => {})
end

Given(/The project has no stories on Pivotal Tracker/) do
  project = Object.new
  iteration = Object.new
  iteration.stub(stories: nil)
  project.stub(current_iteration: iteration)
  allow(PivotalAPI::Project).to receive(:retrieve).and_return(project)
end

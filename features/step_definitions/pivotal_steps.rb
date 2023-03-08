# frozen_string_literal: true

Given(/^The projects? (has|have) some stories on Pivotal Tracker$/) do |_arg|
  project = JSON.parse File.read('spec/fixtures/pivotal_tracker_project_response.json')
  response = File.read('spec/fixtures/pivotal_tracker_project_current_iteration.json')
  json_iterations = JSON.parse(response, { symbolize_names: true })
  iteration_object = PivotalAPI::Iterations.from_json(json_iterations)
  allow(PivotalAPI::Project).to receive(:retrieve).and_return(PivotalAPI::Project.new(project))
  allow(PivotalAPI::Service).to receive(:iterations).and_return(iteration_object)
end

Given(/^The projects? (has|have) no stories on Pivotal Tracker$/) do |_arg|
  project = Object.new
  iteration = Object.new
  iteration.stub(stories: nil)
  project.stub(current_iteration: iteration)
  allow(PivotalAPI::Project).to receive(:retrieve).and_return(project)
end

Given(/^Enviroment should have a valid access token$/) do
  @token = '1e89ef53f12fc327d3b5d8ee007cce23'
end

Given(/^Projet with pivitaltracker_id (\d+) has some information$/) do |id|
  @project_pivotaltracker_response = File.read('spec/fixtures/project_pivotaltracker_response.json')
end

Given(/^I have access to project with pivitaltracker_id (\d+) in PivotalTracker$/) do |id|
  stub_request(:get, 'https://www.pivotaltracker.com/services/v5/projects/'+id.to_s).with(:headers => {'X-TrackerToken' => @token}).to_return(body: @project_pivotaltracker_response)
end


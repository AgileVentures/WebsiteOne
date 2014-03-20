Given(/^Enviroment should have a valid access token$/) do
  @token = '1e90ef53f12fc327d3b5d8ee007cce39'
end

Given(/^Projet with pivitaltracker_id (\d+) has some stories in current$/) do |arg1|
  @stories = File.read('spec/fixtures/project_pivotaltracker_response.json')
end

Given(/^I have access to project with pivitaltracker_id (\d+) in PivotalTracker$/) do |id|
  @project = File.read('spec/fixtures/project_pivotal_project_response.json')
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890?fields=description,labels,name").to_return(body: @project)
end

Given(/^I have access to project iteration with pivitaltracker_id (\d+) in PivotalTracker$/) do |arg1|
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890/iterations?scope=current").to_return(body: @stories)
  @undefind = File.read('spec/fixtures/project_pivotal_third_response.json')
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890/stories?fields=url,name,description,story_type,estimate,current_state,requested_by,owned_by,labels,integration_id,deadline,comments(person(name,id,initials,email,username),text,updated_at,id,created_at,story_id,file_attachments),tasks&filter=id:67243926,67827134,").to_return(body: @undefind)
end


Given(/^Projet with pivitaltracker_id (\d+) has some stories$/) do |arg1|
  @labels = File.read('spec/fixtures/project_pt_labels_response.json')
  @current = File.read('spec/fixtures/project_pt_current_response.json')
  @stories = File.read('spec/fixtures/project_pt_stories_response.json')
end

Given(/^I have access to project pivitaltracker_id (\d+) and his labels$/) do |arg1|
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890?fields=description,labels,name").
    to_return(:status => 200, :body => @labels, :headers => {})
end

Given(/^I have access to project pivitaltracker_id (\d+) and his current$/) do |arg1|
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890/iterations?scope=current").
    to_return(:status => 200, :body => @current, :headers => {})
end

Given(/^I have access to project pivitaltracker_id (\d+) and his stories$/) do |arg1|
  stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/982890/stories?fields=url,name,description,story_type,estimate,current_state,requested_by,owned_by,labels,integration_id,deadline,comments(person(name,id,initials,email,username),text,updated_at,id,created_at,story_id,file_attachments),tasks&filter=id:67243926,65858684,67380958,67380924,67265600,67480006,67381296,67380946,67380812,67620436,65010108,65007268,65356620,65561136,65561206,66035904,66286674,66288066,64891298,63047384,66066822,66864310,66322520,65594598,65110172,67540480,66235364,67621042,66779110,67265734,67604358,67382256,67203928,65424812,65352190,").
    to_return(:status => 200, body: @stories, :headers =>  {})
end

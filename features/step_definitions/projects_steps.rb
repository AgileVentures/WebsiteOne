Then(/^I should see a "([^"]*)" table$/) do |legend|
  within('table#projects') do
    page.should have_css('legend', :text => legend)
  end
end

When(/^I should see column "([^"]*)"$/) do |column|
  within('table#projects thead') do
    page.should have_css('th', :text => column)
  end
end

When(/^There are projects in the database$/) do
  #TODO Y use factoryGirl
  Project.create(title: "Title 1", description: "Description 1", status: "Status 1")
  Project.create(title: "Title 2", description: "Description 2", status: "Status 2")
end

Given(/^the follow projects exist:$/) do |table|
  table.hashes.each do |hash|
    project = Project.create(hash)
    project.save
  end
end

Then /^I should see a form for "([^"]*)"$/ do |form_purpose|
  #TODO YA check if capybara has form lookup method
  case form_purpose
    when 'creating a new project'
      page.should have_text form_purpose
      page.should have_css('form#new_project')
    else
      puts 'OOPS YOU MESSED UP!!!'
      save_and_open_page
  end
end

When(/^I click the "(.*?)" button for project "(.*?)"$/) do |button, title|
 id = Project.find_by_title(title).id
 within("tr##{id}") do
   click_link button
 end
end

# Matches Given I am on.. | When I go to.. | Then I am on..
Given(/^I (go to|.* on)? the "(.*?)" page for project "(.*?)"$/) do |stay_or_go, page, title|
  project = Project.find_by_title title
  method_name = page.downcase + '_project_path'
  edit_project_path_for_id = send method_name, project
  visit edit_project_path_for_id if stay_or_go == 'go to'
  expect(current_fullpath).to eq edit_project_path_for_id
end

def current_fullpath
  URI.parse(current_url).request_uri
end

Then(/^the Destroy button works for "(.*?)"$/) do |project_title|
  unless Project.find_by_title(project_title).nil?
    id = Project.find_by_title(project_title).id
    within("tr##{id}") do
      expect { click_link "Destroy" }.to change(Project, :count).by(-1)
    end
  end
 end

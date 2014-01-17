#Then(/^I should see a "([^"]*)" table$/) do |legend|
#  within('table#projects') do
#    page.should have_css('legend', :text => legend)
#  end
#end

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

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    project = Project.create(hash)
    project.save!
  end
end

Then /^I should see a form for "([^"]*)"$/ do |form_purpose|
  case form_purpose
    when 'creating a new project'
      page.should have_text form_purpose
      page.should have_css('form#new_project')
  end
end

When(/^I click the "([^"]*)" button for project "([^"]*)"$/) do |button, project_name|
  project = Project.find_by_title(project_name)
  if project
    within("tr##{project.id}") do
      click_link_or_button button
    end
  else
    visit path_to(button, 'non-existent')
  end
end

Given(/^I am on the "([^"]*)" page for project "([^"]*)"$/) do |page_name, project_name|
  steps %Q{
    Given I am logged in
    And I am on the "projects" page
    And I click the "#{page_name}" button for project "#{project_name}"
  }
end

Then(/^I should see "([^"]*)" table$/) do |legend|
  page.should have_css 'h1', text: legend
end

When(/^I should see column "([^"]*)"$/) do |column|
  within('table#projects thead') do
    page.should have_css('th', :text => column)
  end
end

When(/^There are projects in the database$/) do
  Project.create(title: "Title 1", description: "Description 1", status: "Status 1")
  Project.create(title: "Title 2", description: "Description 2", status: "Status 2")
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    project = Project.create(hash)
    project.save
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

When(/^(.*) in the list of projects$/) do |s|
  page.within(:css, 'table#projects') { step(s) }
end

# Bryan: Replaced with more general step
#Given(/^I am on the "([^"]*)" page for project "([^"]*)"$/) do |page_name, project_name|
#  steps %Q{
#    Given I am logged in
#    And I am on the "projects" page }
#  if page_name == 'Show'
#    steps %Q{ And I click "#{project_name}" }
#  else
#    steps %Q{ And I click the "#{page_name}" button for project "#{project_name}" }
#  end
#end


Given(/^the document "([^"]*)" has a child document with title "([^"]*)"$/) do |parent, child|
  parent_doc = Document.find_by_title(parent)
  parent_project_id = parent_doc.project_id
  child_doc = parent_doc.children.create!( { :project_id => parent_project_id,:title => child })
end

Then(/^I should become a member of project "([^"]*)"$/) do | name|
  object = Project.find_by_title(name)
  @user.follow(object)
end

When(/^I am a member of project "([^"]*)"$/) do |name|
  step %Q{I should become a member of project "#{name}"}
end
Then(/^I should stop being a member of project "([^"]*)"$/) do |name|
  object = Project.find_by_title(name)
  @user.stop_following(object)
end
When(/^I am not a member of project "([^"]*)"$/) do |name|
  step %Q{I should stop being a member of project "#{name}"}
end

Given(/^I am on the home page$/) do
  visit "/"
end
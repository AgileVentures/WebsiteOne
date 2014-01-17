def path_to(page_name, id = '')
  name = page_name.downcase
  case name
    when 'home' then
      root_path
    when 'registration' then
      new_user_registration_path
    when 'sign in' then
      new_user_session_path
    when 'projects' then
      projects_path
    when 'new project' then
      new_project_path
    when 'edit' then
      edit_project_path(id)
    when 'show' then
      project_path(id)
    else
      raise('path to specified is not listed in #path_to')
  end
end

# GIVEN steps

Given(/^I am on the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

# WHEN steps
When(/^I go to the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

When(/^I click "([^"]*)"$/) do |text|
  click_button text
end

When(/^I follow "([^"]*)"$/) do |text|
  click_link text
end

And(/^I click the "([^"]*)" button$/) do |button|
  click_link_or_button button
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in field, :with => value
end

# THEN steps

Then /^I should be on the "([^"]*)" page$/ do |page|
  expect(current_path).to eq path_to(page)
end

#Then /^I am redirected to the "([^"]*)" page$/ do |page|
#  expect(current_path).to eq path_to(page)
#end

Then /^I should see:$/ do |table|
  table.rows.flatten.each.each do |string|
    page.should have_text string
  end
end

Then /^I should see "([^"]*)"$/ do |string|
  page.should have_text string
end

Then /^I should see link "([^"]*)"$/ do |link|
  page.should have_link link
end

Then /^I should see field "([^"]*)"$/ do |field|
  page.should have_field(field)
end

Then /^I should( not)? see button "([^"]*)"$/ do |negative, name|
  unless negative
    expect(page.has_link?(name) || page.has_button?(name)).to be_true
  else
    expect(page.has_link?(name) || page.has_button?(name)).to be_false
  end
end

Then(/^show me the page$/) do
  save_and_open_page
end



# unused steps
Given(/^I visit the site$/) do
  visit root_path
end

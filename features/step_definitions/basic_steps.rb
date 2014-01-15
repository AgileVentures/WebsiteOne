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
  end
end

Then /^I should( not)? see button "([^"]*)"$/ do |negative, name|
  if negative
    page.should_not have_link name
  else
    page.should have_link name
  end
end

Given(/^I visit the site$/) do
  visit root_path
end

Given(/^I am on the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

And(/^I am redirected to the "([^"]*)" page$/) do |page|
  expect(current_path).to eq path_to(page)
end

Given(/^I go to the "([^"]*)" page$/) do |page|
  visit path_to(page)
end

Then(/^I should be on the ([^"]*) page$/) do |page|
  expect(current_path).to eq path_to(page)
end

When(/^I submit "([^"]*)" as username$/) do |email|
  fill_in('Email', :with => email)
end

When(/^I submit "([^"]*)" as password$/) do |password|
  fill_in('Password', :with => password)
  fill_in('Password confirmation', :with => password)
end

When(/^I click "([^"]*)"$/) do |text|
  click_button text
end

When(/^I follow "([^"]*)"$/) do |text|
  click_link text
end

When /^I should see "([^"]*)"$/ do |string|
  page.should have_text string
end


When(/^I should see a "([^"]*)" link$/) do |link|
  page.should have_link link
end

Then(/^show me the page$/) do
  save_and_open_page
end

When(/^I am logged in as a user$/) do
  #page.stub(:user_signed_in?).and_return(true)
end

Then(/^I should see field "([^"]*)"$/) do |field|
  page.should have_field(field)
end

When(/^I should see form button "([^"]*)"$/) do |button|
  page.should have_button button
end

And(/^I click the "([^"]*)" button$/) do |button|
  click_link_or_button button
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in field, :with => value
end

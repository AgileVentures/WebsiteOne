def path_to(page)
  case page
    when 'home' then root_path
    when 'registration' then new_user_registration_path
    when 'sign in' then new_user_session_path
    when 'projects' then projects_path
  end
end

Then /^I should see a button "([^"]*)"$/ do |name|
  page.should have_link name
end


Given(/^I visit the site$/) do
  visit root_path
end

Given(/^I am on the ([^"]*) page$/) do |page|
  visit path_to(page)
end

Given(/^I go to the ([^"]*) page$/) do |page|
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
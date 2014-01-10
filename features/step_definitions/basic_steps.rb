Then /^I should see a button "([^"]*)"$/ do |name|
  page.should have_button name
end


Given(/^I visit the site$/) do
  visit root_path
end

Given(/^I am on the ([^"]*) page$/) do |page|
  case page
    when "home" then visit root_path
    when "registration" then visit new_user_registration_path
    when "sign in" then visit new_user_session_path
  end

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

Then(/^I should be on the ([^"]*) page$/) do |page|
 case page
   when "home" then expect(current_path).to eq(root_path)
   when "registration" then expect(current_path).to eq(new_user_registration_path)
 end
end

When /^I should see "([^"]*)"$/ do |string|
  page.should have_text string
end


When(/^I should see a "([^"]*)" link$/) do |link|
  page.should have_link link
end


Then(/^show me the page$/) do
  #save_and_open_page
end
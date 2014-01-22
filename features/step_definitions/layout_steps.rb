Then(/^I should see a navigation header$/) do
  page.should have_selector('header.masthead')
end

Then(/^I should see a main content area$/) do
  page.should have_selector('section#main')
end

Then(/^I should see a footer area$/) do
  page.should have_selector('section#footer')
end

Then(/^I should see a navigation bar$/) do
    find ('div.navbar')
end
When(/^I should see "([^"]*)" in footer$/) do |string|
  within('section#footer') do
    page.should have_text string
  end
end

Then /^I should see link$/ do |table|
  table.rows.flatten.each do |link|
    page.should have_link link
  end
end
# frozen_string_literal: true

Then(/^I(?:| should) see a navigation header$/) do
  expect(page).to have_selector('.masthead')
end

Then(/^I should see a main content area$/) do
  expect(page).to have_selector '#main'
end

Then(/^I should see a footer area$/) do
  expect(page).to have_selector '#footer'
end

Then(/^I should see a navigation bar$/) do
  find '#nav'
end

When(/^I should see "([^"]*)" in footer$/) do |string|
  within('#footer') do
    expect(page).to have_text string
  end
end

Then /^I should see link$/ do |table|
  table.rows.flatten.each do |link|
    expect(page).to have_link link
  end
end

Then(/^I should see a modal window with a form "([^"]*)"$/) do |arg|
  expect(page).to have_content(arg)
end

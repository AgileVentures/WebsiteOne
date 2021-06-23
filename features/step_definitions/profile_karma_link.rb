# frozen_string_literal: true

Given(/^I click on the karma link$/) do
  click_link('gotoactivity')
end

Then(/^the Activity tab displays "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^the Activity tab does not display "([^"]*)"$/) do |arg1|
  expect(page).not_to have_content(arg1)
end

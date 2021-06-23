# frozen_string_literal: true

Then(/^the page should be titled "(.*?)"$/) do |title|
  expect(page.source).to have_css('title', text: title, visible: false)
end

And(/^the response status should be "([^"]*)"$/) do |code|
  expect(page.status_code).to eql(code.to_i)
end

When(/^I encounter an internal server error$/) do
  expect_any_instance_of(VisitorsController).to receive(:index).and_raise(Exception)
  visit root_path
end

And(/^The admins should receive an error notification email$/) do
  step 'I should receive a "ERROR" email'
end

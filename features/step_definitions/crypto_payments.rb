When(/^I go to the new subscriptions page$/) do
  visit "/subscriptions/new"
end

Then(/^I should see text "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end


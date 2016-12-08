Then(/^my member page should show premium details$/) do
  visit
  expect(page).to have_content "Premium"
end

Then(/^I should be redirected to Paypal's payment screens$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
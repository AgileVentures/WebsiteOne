Then(/^I should see a list of guides$/) do
  expect(page).to have_css "ul#guides-list"
end

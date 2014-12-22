Then(/^I should see "(.*?)" tab is active$/) do |tab|
  expect(page).to have_css "##{tab.downcase}.active"
end
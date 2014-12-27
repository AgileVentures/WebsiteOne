Then(/^I should see "(.*?)" tab (?:set to|is) active$/) do |tab|
  expect(page).to have_css "##{tab.downcase}.active"
end
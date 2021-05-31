# frozen_string_literal: true

Then(/^I should see a "(.*?)" tab (?:set to|is) (.*?)$/) do |tab, state|
  expect(page).to have_css "##{tab.downcase}.#{state}"
end

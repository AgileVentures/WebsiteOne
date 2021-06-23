# frozen_string_literal: true

Then(/^I should see a start jitsi meet button with link "([^"]*)"$/) do |url|
  expect(page).to have_css('#start-jitsi')
  url = page.find(:css, '#start-jitsi').find(:xpath, '..')[:href]
  expect(url).to eq url
end

Then(/^I should see sponsor banner for "(.*?)"$/) do |supporter_name|
  expect(page).to have_selector('div#sponsorsBar')
  expect(page).to have_css("img[alt*='#{supporter_name}']")
end

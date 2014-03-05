Then(/^I should see sponsor banner for "(.*?)"$/) do |arg1|
  page.should have_selector('div#sponsorsBar')
  page.should have_css("img[src*='w3schools']")
end


Then(/^I should see sponsor banner for "(.*?)"$/) do |supporter_name|
  page.should have_selector('div#sponsorsBar')
  page.should have_css("img[alt*='#{supporter_name}']")
end

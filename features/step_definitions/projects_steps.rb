Then(/^I should see a "([^"]*)" table$/) do |legend|
  within('table#projects thead') do
    page.should have_css('legend', :text => legend)
  end
end
When(/^I should see column (.*)$/) do |column|
  within('table#projects thead') do
    page.should have_css('th', :text => column)
  end
end
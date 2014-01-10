Then(/^I should see a "([^"]*)" table$/) do |legend|
  within('table#projects') do
    page.should have_css('legend', :text => legend)
  end
end

When(/^I should see column (.*)$/) do |column|
  within('table#projects thead') do
    page.should have_css('th', :text => column)
  end
end

When(/^I should see button (.*)$/) do |link|
  within('table#projects thead') do
    p link
    page.should have_link link
  end
end
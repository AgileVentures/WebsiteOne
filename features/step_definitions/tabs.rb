When(/^I should copy current url$/) do
  @uri = current_url
  puts @uri
end

Then(/^I should open new broswer past copies url$/) do
  visit @uri
end

Then(/^I should see "(.*?)" tab is active$/) do |tab|
    page.find(:css, '#' + tab + ".active")
end




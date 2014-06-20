#When(/^I should copy current url$/) do
#  @uri = current_url
#  puts @uri
#end
#
#Then(/^I should open new browser past copies url$/) do
#  visit @uri
#end

Then(/^I should see "(.*?)" tab is active$/) do |tab|
  # add timeout untill the page gets built
  Timeout::timeout(3.0) {
    until page.has_css?("##{tab}.active") do
      sleep(0.005)
    end
  }
  page.should have_css "##{tab}.active"
end

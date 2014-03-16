#When(/^I should copy current url$/) do
#  @uri = current_url
#  puts @uri
#end
#
#Then(/^I should open new browser past copies url$/) do
#  visit @uri
#end

Then(/^I should see "(.*?)" tab is active$/) do |tab|
    page.should have_css "##{tab}.active"
end

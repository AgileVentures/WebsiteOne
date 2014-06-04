

Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  expect(dates.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Given(/^I click a scrum in timeline$/) do
  page.first(:css, "a.yt_link").click
end

Then(/^I should see a modal window with title "(.*?)"$/) do |header|
  page.evaluate_script("$('.modal').css('display')").should eq "block"
  page.should have_selector('#playerTitle', text: header)
end

Then(/^I should not see a modal window$/) do
  page.evaluate_script("$('.modal').css('display')").should eq "none"
end

When(/^I close the video window$/) do
    pending # express the regexp above with the code you wish you had
end

Then(/^the video should stop playing$/) do
    pending # express the regexp above with the code you wish you had
end

#TODO: Marcelo: we will use below code to persist scrums to db

#Given /^the following scrums exist in the db:$/ do |table|
#    table.hashes.each do |hash|
#      Scrum.new(hash)
#    end
#end
#When /^a request is made to "([^"]*)"$/ do |url|
#  @response = Net::HTTP.get_response(URI.parse(url))
#end





Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  expect(dates.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Given(/^I play a video$/) do
  playvideo = page.first(:xpath, "//h4[@class=\"timeline-title\"]/a[contains(@class,\"yt_link\")]")['href']
  click_link playvideo
nd

Then(/^I should see a modal window with the second scrum$/) do
  page.evaluate_script("$('.modal').css('display')").should eq "block"
  title = page.body.gsub(/\n/,'').scan(/<\/span><\/a>\s*(.*?)\s*<\/h4>/)[1]
  page.should have_selector('#playerTitle', text: title[0])
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

When(/^I stop the video$/) do
    pending # express the regexp above with the code you wish you had
end

When(/^I click the first scrum in the timeline$/) do
  page.first(:css, "a.yt_link").click
end

When(/^I click the second scrum in the timeline$/) do
  page.all(:css, "a.yt_link")[1].trigger('click')
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



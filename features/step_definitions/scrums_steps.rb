

Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  expect(dates.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
end

Given(/^I play a video$/) do
<<<<<<< HEAD
  #link = "http://www.youtube.com/v/Lj2aa65_KuA?version=3&f=videos&d=AfpKN7G_219h8WqHh6SoEXEO88HsQjpE1a8d1GxQnGDm&app=youtube_gdata"
  link = "http://www.youtube.com/v/KdcNSYIX0JQ?version=3&amp;f=videos&amp;d=AfpKN7G_219h8WqHh6SoEXEO88HsQjpE1a8d1GxQnGDm&amp;app=youtube_gdata"
  visit(link)
=======
  page.first(:xpath, "//h4[@class=\"timeline-title\"]").click
>>>>>>> 3af813c263e21c6ee316f42c3ba14ede6006781a
end





Then(/^I should see a modal window with the video$/) do
  pending
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





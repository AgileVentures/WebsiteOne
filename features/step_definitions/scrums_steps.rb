

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
  playvideo = page.first(:xpath, "//h4[@class=\"timeline-title\"]/a[contains(@class,\"yt_link\")]")['href']
  click_link playvideo
=======
  #http://www.youtube.com/v/Lj2aa65_KuA?version=3&f=videos&d=AfpKN7G_219h8WqHh6SoEXEO88HsQjpE1a8d1GxQnGDm&app=youtube_gdata
  debugger
  elem = page.first(:xpath, "//h4[@class=\"timeline-title\"]/a[contains(@class,\"yt_link\")]")['id'] 
  #//"http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  page.click_link(elem)
  puts 'lol'
>>>>>>> 6765e355a1925282fd40663c9e3ceee52f36ded2
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





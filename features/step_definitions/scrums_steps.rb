require 'net/http'

Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do
  dates = page.text.scan(/\d{4}-\d{2}-\d{2}/)
  expect(dates.count).to eq(20)
  expect(dates.sort { |x,y| y <=> x }).to eq(dates)
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





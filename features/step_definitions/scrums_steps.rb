require 'net/http'

Given(/^I visit "(.*?)" page$/) do |path|
  visit path
end


Then(/^I should see 20 scrums in descending order by published date:$/) do |table|
  expected_order = table.raw.flatten
  actual_order = page.all('li.timeline-title').collect(&:text)
  actual_order.should eq expected_order
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





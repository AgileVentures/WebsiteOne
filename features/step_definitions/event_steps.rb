Given(/^I am on Events index page$/) do
  visit('/events')
end
Given(/^following events exist:$/) do |table|
  # table is a | Scrum      | Daily scrum meeting     | 2014/02/01 | 2014/02/01 | false      |
  table.hashes.each do |hash|
    Event.create(hash)
    puts Event.last.name
  end

end
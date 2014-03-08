require 'delorean'

Given(/^I am on Events index page$/) do
  visit('/events')
end

Given(/^following events exist:$/) do |table|
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
  Delorean.time_travel_to(Time.parse('2014/02/01 09:15:00 UTC'))
  table.hashes.each do |hash|
    Event.create(hash)
  end

end

Then(/^I should be on the Events index page$/) do
  current_path.should eq events_path
end

Then(/^I should see multiple "([^"]*)" events$/) do |event|
  puts Time.now
  page.all(:css, 'a', text: event, visible: false).count.should be > 1
end

When(/^the next event should be in:$/) do |table|
  table.rows.each do |period, interval|
    page.should have_content([period, interval].join(' '))
  end

end


Then(/^I want to get back to the present$/) do
  Delorean.back_to_the_present
  ENV['TZ'] = @default_tz
end


Given(/^I am on the show page for event "([^"]*)"$/) do |name|
  steps %Q{
      Given I am on Events index page
      And I click "#{name}"
  }
end

Then(/^I should be on the event "([^"]*)" page for "([^"]*)"$/) do |page, name|
  event = Event.find_by_name(name)
  page.downcase!
  case page
    when 'show'
      current_path.should eq event_path(event)

    else
      current_path.should eq eval("#{page}_event_path(event)")

  end
end
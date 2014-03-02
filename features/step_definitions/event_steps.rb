require 'delorean'

Given(/^I am on Events index page$/) do
  visit('/events')
end
Given(/^following events exist:$/) do |table|
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
  Delorean.time_travel_to(Time.parse("2014/02/01 09:15:00 UTC"))
  table.hashes.each do |hash|
    Event.create(hash)
    #@event = Event.new(hash)
    #@event.save(:validate=>false)

  end
  #ActionView::Base.any_instance.stub(:cover_for) { image_path('event-scrum-cover.png') }

end

Then(/^I should be on the Events index page$/) do
  current_path.should eq events_path
end

Then(/^I should see multiple "([^"]*)" events$/) do |event|
  puts page.body
  page.all(:css, 'a', text: event, visible: false).count.should be > 1
end
When(/^the next event should be in:$/) do |table|
  # today = mock_current_time(DateTime, '2014-02-01 09:15:00 UTC')

  table.rows.each do |period, interval|
    page.should have_content([period, interval].join(' '))
  end

  Delorean.back_to_the_present
  ENV['TZ'] = @default_tz
end

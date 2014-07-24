Given(/^I am on Events index page$/) do
  visit events_path
end

Given(/^following events exist:$/) do |table|
  table.hashes.each do |hash|
    Event.create!(hash)
  end
end

Then(/^I should be on the Events "([^"]*)" page$/) do |page|
  case page.downcase
    when 'index'
      current_path.should eq events_path

    when 'create'
      current_path.should eq events_path

    else
      pending
  end
end

Then(/^I should see multiple "([^"]*)" events$/) do |event|
  #puts Time.now
  page.all(:css, 'a', text: event, visible: false).count.should be > 1
end

When(/^the next event should be in:$/) do |table|
  table.rows.each do |period, interval|
    page.should have_content([period, interval].join(' '))
  end
end

Given(/^I am on the show page for event "([^"]*)"$/) do |name|
  event = Event.find_by_name(name)
  visit event_path(event)
end

Given(/^I am on the edit page for event "([^"]*)"$/) do |name|
  event = Event.find_by_name(name)
  visit edit_event_path(event)
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

Given(/^the date is "([^"]*)"$/) do |jump_date|
  Delorean.time_travel_to(Time.parse(jump_date))
end


And(/^I fill in event year with "([^"]*)"$/) do |year|
  select year, :from => "event_event_date_1i"
end

And(/^I fill in event month with "([^"]*)"$/) do |month|
  select month, :from => "event_event_date__2i"
end

And(/^I fill in event day with "([^"]*)"$/) do |day|
  select day, :from => "event_event_date_3i"
end
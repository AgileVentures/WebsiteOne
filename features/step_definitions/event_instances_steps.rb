starting_date = 1.year.ago

Given /^(\d+) event instances? exists?$/ do |num_event_instances|

  num_event_instances.to_i.times do |num|
    created_at_date = starting_date + num.days
    EventInstance.create title: "Bob's mob", event_id: 3, category: "Scrum", yt_video_id: "fake_id_#{num}", created_at: "#{created_at_date}"
  end
end

When /^a user views the event "([^"]*)"$/ do |event|
  event = Event.find_by name: event
  visit event_path event
end

Then /^they should see (\d+) event instances$/ do |num_event_instances|
  expect(page).to have_css('#recent_event_list li', count: num_event_instances)
end

Then /^they should see a message stating: "([^"]*)"$/ do |message|
  expect(page).to have_content message
end

Then /^they should see all information for the instance "([^"]*)"$/ do |event_instance|
  event_instance = EventInstance.find_by title: event_instance
  expect(page).to have_css('#recent_event_list li', text: "#{event_instance.created_at.strftime '%A, %B %e, %Y'} - ")
  expect(page).to have_link("link to video", href: "https://www.youtube.com/watch?v=#{event_instance.yt_video_id}")
end

Given /^(\d+) event instance exists without a youtube id$/ do |num_event_instances|
  num_event_instances.to_i.times do
    EventInstance.create title: "Bob's mob", event_id: 3, category: "Scrum"
  end
end

Then /^they should see the most (\d+) recent events first$/ do |num_event_instances|
  most_recent_events_first = ''
  num_event_instances.to_i.times.reverse_each do |num|
    next_recent_event = starting_date + num.days
    next_recent_event = next_recent_event.strftime('%A, %B %e, %Y').to_s
    most_recent_events_first << next_recent_event + '.*'
  end
  expect(page.text).to match(Regexp.new(most_recent_events_first))
end

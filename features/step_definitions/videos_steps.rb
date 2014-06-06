Then /^I should see hangout button$/ do
  src = page.find(:css,'#HOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Given /^the Hangout for event "([^"]*)" has been started$/ do |event|
  event = Event.find_by_name(name)
  Video.create(video_id: event.id, hangout_url: 'http://test.hangout')
end

Then /^I should see a link to the hangout for the event "([^"]*)"$/ do |event|
  event = Event.find_by_name(name)
  url = Video.find(event).hangout_url
  expect(page).to have_link(name, href: url)
end

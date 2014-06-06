Then /^I should see hangout button$/ do
  src = page.find(:css,'#HOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Given /^the Hangout for event "([^"]*)" has been started$/ do |name|
  event = Event.find_by_name(name)
  Video.create(video_id: event.id.to_s, hangout_url: 'http://test.hangout')
end

Then /^I should see a link "([^"]*)" for the event "([^"]*)"$/ do |link, name|
  event = Event.find_by_name(name)
  url = Video.find(event).hangout_url
  expect(page).to have_link(link, href: url)
end

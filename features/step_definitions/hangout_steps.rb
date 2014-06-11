Then /^I should see hangout button$/ do
  src = page.find(:css,'#liveHOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Then /^I should see a hangout link "([^"]*)" for the event "([^"]*)"$/ do |link, name|
  event = Event.find_by_name(name)
  expect(page).to have_link(link, href: 'http://hangout.test')
end

Given /^the Hangout for event "([^"]*)" has been started with details:$/ do |event_name, table|
  ho_details = table.transpose.hashes
  hangout = ho_details[0]

  event = Event.find_by_name(event_name)
  Hangout.create(event_id: event.id.to_s,
               hangout_url: hangout['Hangout link'])
end

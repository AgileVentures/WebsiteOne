Then /^I should see hangout button$/ do
  src = page.find(:css,'#HOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Given /^the Hangout for event "([^"]*)" has been started$/ do |name|
end

Then /^I should see a link "([^"]*)" for the event "([^"]*)"$/ do |link, name|
  event = Event.find_by_name(name)
  url = Video.find(event).hangout_url
  expect(page).to have_link(link, href: url)
end


Given /^the Hangout for event "([^"]*)" has been started with details:$/ do |event_name, table|
  ho_details = table.transpose.hashes
  currently_in, participants = [], []

  ho_details.each do |hash|
    currently_in << hash['Currently in']
    participants << hash['Participants']
  end

  hangout = ho_details[0]
  hangout['Currently in'] = currently_in.reject(&:empty?)
  hangout['Participants'] = participants.reject(&:empty?)

  event = Event.find_by_name(event_name)
  v = Video.create(video_id: event.id.to_s,
               host: hangout['Host'],
               hangout_url: hangout['Hangout link'],
               youtube_id: hangout['Youtube id'],
               created_at: hangout['Start time'],
               currently_in: hangout['Currently in'],
               participants: hangout['Participants'])
  debugger
  

end

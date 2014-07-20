Then /^I should see hangout button$/ do
  src = page.find(:css,'#liveHOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Then /^the hangout button should( not)? be visible$/ do |negative|
  section = page.find('#hangout-btn', visible: false)
  if negative
    expect(section).not_to be_visible
  else
    expect(section).to be_visible
  end
end

Given /^the Hangout for event "([^"]*)" has been started with details:$/ do |event_name, table|
  ho_details = table.transpose.hashes
  hangout = ho_details[0]
  event = Event.find_by_name(event_name)

  Hangout.record_timestamps = false
  Hangout.create(uid: '123456', event_id: event.id.to_s,
               hangout_url: hangout['Hangout link'],
               updated_at: hangout['Started at'] ? Time.parse(hangout['Started at']) : Time.now)
  Hangout.record_timestamps = true
end

Then /^I should( not)? see Hangouts details section$/ do |negative|
  section = page.find('.hangout-details', visible: false)
  if negative
    expect(section).not_to be_visible
  else
    expect(section).to be_visible
  end
end

Then /^I have Slack notifications enabled$/ do
  stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify').to_return(status: 200)
end

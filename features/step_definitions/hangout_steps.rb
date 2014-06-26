Then /^I should see hangout button$/ do
  src = page.find(:css,'#liveHOA-placeholder iframe')['src']
  expect(src).to match /talkgadget.google.com/
end

Then /^the hangout button should( not)? be visible$/ do |negative|
  if negative
    expect(page).not_to have_css('#hangout_button', visible: true)
  else
    expect(page).to have_css('#hangout_button')
  end
end

Then /^I should see link "([^"]*)" with "([^"]*)"$/ do |link, url|
  expect(page).to have_link(link, href: url)
end

Given /^the Hangout for event "([^"]*)" has been started with details:$/ do |event_name, table|
  ho_details = table.transpose.hashes
  hangout = ho_details[0]
  event = Event.find_by_name(event_name)

  Hangout.record_timestamps = false
  Hangout.create(event_id: event.id.to_s,
               hangout_url: hangout['Hangout link'],
               updated_at: hangout['Started at'] ? Time.parse(hangout['Started at']) : Time.now)
  Hangout.record_timestamps = true
end

Then /^I should( not)? see Hangouts details section$/ do |negative|
  if negative
    expect(page).not_to have_css('#hangout_details')
  else
    expect(page).to have_css('#hangout_details')
  end
end

Given /^the time now is "([^"]*)"$/ do |time|
  Time.stub(now: Time.parse(time))
end


Then /^I have Slack notifications enabled$/ do
  stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify').to_return(status: 200)
end

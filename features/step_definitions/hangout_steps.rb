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


  start_time = hangout['Started at'] ? hangout['Started at'] : Time.now
  event = Event.find_by_name(event_name)

  FactoryGirl.create(:event_instance, event: event,
               hangout_url: hangout['EventInstance link'],
               updated_at: start_time)
end

Given /^the following hangouts exist:$/ do |table|
  table.hashes.each do |hash|
    participants = hash['Participants'] || []
    participants = participants.split(',')

    participants = participants.map do |participant|
      break if participant.empty?
      name = participant.squish
      user = User.find_by_first_name(name)
      gplus_id = user.authentications.find_by(provider: 'gplus').try!(:uid) if user.present?
      [ "0", { :person => { displayName: "#{name}", id: gplus_id } } ]
    end

    event_instance = FactoryGirl.create(:event_instance,
                 title: hash['Title'],
                 project: Project.find_by_title(hash['Project']),
                 event: Event.find_by_name(hash['Event']),
                 category: hash['Category'],
                 user: User.find_by_first_name(hash['Host']),
                 hangout_url: hash['EventInstance url'],
                 participants: participants,
                 yt_video_id: hash['Youtube video id'],
                 created: hash['Start time'],
                 updated: hash['End time'])
  end
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

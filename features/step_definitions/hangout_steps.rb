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

Given /^the following hangouts exist:$/ do |table|
  table.hashes.each do |hash|
    hangout = Hangout.create
    params = { title: hash['Title'],
               project_id: Project.find_by_title(hash['Project']).try!(:id),
               event_id: Event.find_by_name(hash['Event']).try!(:id),
               category: hash['Category'],
               host_id: User.find_by_first_name(hash['Host']).try!(:id),
               hangout_url: hash['Hangout url'],
               yt_video_id: hash['Youtube video id']
             }

    if participants = hash['Participants']
      participants = participants.split(',')

      params[:participants] = participants.map do |participant|
        name = participant.squish
        { name: name,
          gplus_id: User.find_by_first_name(name).try!(:youtube_id)
        }
      end
    end
    hangout.update_hangout_data(params)
    hangout.update(updated_at: hash['Start time'])
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

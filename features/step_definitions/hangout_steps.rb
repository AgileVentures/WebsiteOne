Given(/^I navigate to the show page for event "([^"]*)"$/) do |name|
  event = Event.find_by_name(name)
  visit event_path(event)
end

Then(/^I jump to one minute before the end of the event at "([^"]*)"/) do |jump_date|
  Delorean.time_travel_to(Time.parse(jump_date))
end


Then /^I should (not )?see hangout button$/ do |absent|
  if absent
    expect(page).not_to have_css '#hoa_instructions'
  else
    expect(page).to have_css "#hoa_instructions"
  end
end

Given /^the Hangout for event "([^"]*)" has been started with details:$/ do |event_name, table|
  ho_details = table.transpose.hashes
  hangout = ho_details[0]

  start_time = hangout['Started at'] ? Time.parse(hangout['Started at']) : Time.now
  update_time = hangout['Updated at'] ? Time.parse(hangout['Updated at']) : start_time
  event = Event.find_by_name(event_name)
  FactoryBot.create(:event_instance,
                     event_id: event.id,
                     hangout_url: hangout['EventInstance link'],
                     created: start_time,
                     updated_at: update_time,
                     hoa_status: 'live',
                     youtube_tweet_sent: true)

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
      ["0", {'person' => {displayName: "#{name}", 'id' => gplus_id}}]
    end

    FactoryBot.create(:event_instance,
                       title: hash['Title'],
                       project: Project.find_by_title(hash['Project']),
                       event: Event.find_by_name(hash['Event']),
                       category: hash['Category'],
                       user: User.find_by_first_name(hash['Host']),
                       hangout_url: hash['EventInstance url'],
                       participants: participants,
                       yt_video_id: hash['Youtube video id'],
                       created: hash['Start time'],
                       updated: hash['End time'],
                       youtube_tweet_sent: hash['Youtube tweet sent'])
  end
end

Then /^I have Slack notifications enabled$/ do
  stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify').to_return(status: 200)
end

Given(/^(\d+) hangouts exists$/) do |count|
  count.to_i.times { FactoryBot.create :event_instance }
end

Then(/^I should see (\d+) hangouts$/) do |count|
  expect(page).to have_content("Hangout_", count: count.to_i)
end

When(/^I scroll to bottom of page$/) do
  page.evaluate_script("window.scrollTo(0, $(document).height());")
  sleep 2
end

And(/^there should be three snapshots$/) do
  @hangout.reload
  expect(@hangout.hangout_participants_snapshots.count).to eq 3
end

And(/^the following event instances \(with default participants\) exist:$/) do |table|
  participants = {"0" => {"id" => "hangout2750757B_ephemeral.id.google.com^a85dcb4670", "hasMicrophone" => "true", "hasCamera" => "true", "hasAppEnabled" => "true", "isBroadcaster" => "true", "isInBroadcast" => "true", "displayIndex" => "0", "person" => {"id" => "108533475599002820142", "displayName" => "Alejandro Babio", "image" => {"url" => "https://lh4.googleusercontent.com/-p4ahDFi9my0/AAAAAAAAAAI/AAAAAAAAAAA/n-WK7pTcJa0/s96-c/photo.jpg"}, "na" => "false"}, "locale" => "en", "na" => "false"}}
  table.hashes.each do |hash|
    hash[:event] = Event.find_by name: hash[:event]
    hash[:project] = Project.find_by title: hash[:project]
    hash[:participants] = participants
    EventInstance.create hash
  end
end

Then(/^there should be exactly (\d+) hangouts$/) do |number|
  expect(EventInstance.count).to eq number.to_i
end

Then(/^there should be exactly (\d+) hangouts associated with "([^"]*)"$/) do |number, project|
  project = Project.find_by(title: project)
  expect(EventInstance.where(project: project).count).to eq number.to_i
end

And(/^I manually set a hangout link for event "([^"]*)"$/) do |name|
  @hangout_url = 'https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0'
  event = Event.find_by_name(name)
  visit event_path(event)
  page.execute_script(  %q{$('li[role="edit_hoa_link"] > a').trigger('click')}  )
  fill_in 'hangout_url', :with => @hangout_url
  page.find(:css, %q{input[id="hoa_link_save"]}).trigger('click')
  visit event_path(event)
end

Then(/^"([^"]*)" shows live for that hangout link for the event duration$/) do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).to have_link('Join now', href: @hangout_url)
  time = Time.parse(@jump_date) + event.duration.minutes - 10.minutes
  Delorean.time_travel_to(time)
  visit event_path(event)
  expect(page).to have_link('Join now', href: @hangout_url)
  time = Time.parse(@jump_date) + event.duration.minutes + 10.minutes
  Delorean.time_travel_to(time)
  visit event_path(event)
  expect(page).not_to have_link('Join now')
end

Given(/^"([^"]*)" doesn't go live$/) do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).not_to have_link('Join now')
end

And(/^"([^"]*)" is not live the following day$/) do |event_name|
  event = Event.find_by_name(event_name)
  Delorean.time_travel_to(Time.parse(@jump_date) + 1.day)
  visit event_path(event)
  expect(page).not_to have_content('This event is now live!')
end

Given(/^that "([^"]*)" went live the previous day$/) do |name|
  steps %Q{
    Given the date is "2014 Feb 5th 6:00am"
    And I manually set a hangout link for event "Repeat Scrum"
  }
  event = Event.find_by_name(name)
  visit event_path(event)
end

Then(/^it should not go live the next day just because the event start time is passed$/) do
  steps %Q{
    Given the date is "2014 Feb 5th 7:05am"
    Then "Repeat Scrum" doesn't go live
  }
end

Then(/^"([^"]*)" shows youtube link with youtube id "([^"]*)"$/) do |event_name, yt_id|
  yt_url = 'https://youtu.be/' + yt_id
  visit event_path(Event.find_by_name(event_name))
  page.execute_script(  %q{$('li[role="edit_yt_link"] > a').trigger('click')}  )
  page.should have_field('yt_url', with: yt_url)
end

Given(/^I manually set youtube link with youtube id "([^"]*)" for event "([^"]*)"$/) do |yt_id, event_name|
  yt_url = 'https://youtu.be/' + yt_id
  event = Event.find_by_name(event_name)
  visit event_path(event)
  page.execute_script(  %q{$('li[role="edit_yt_link"] > a').trigger('click')}  )
  fill_in 'yt_url', :with => yt_url
  page.find(:css, %q{input[id="yt_link_save"]}).trigger('click')
  visit event_path(event)
end

Then(/^I should see video with youtube id "([^"]*)"$/) do |yt_id|
  expect(page.find(:css, '#ytplayer')[:src]).to include "www.youtube.com/embed/#{yt_id}"
end

Then(/^Hangout link does not change for "([^"]*)"$/) do |event_name|
  visit event_path(Event.find_by_name(event_name))
  page.execute_script(  %q{$('li[role="edit_hoa_link"] > a').trigger('click')}  )
  page.should have_field('hangout_url', with: @hangout_url)
end

Then(/^a separate event instance is not created$/) do
  expect(EventInstance.where("created_at >= ?", Time.now.beginning_of_day).size)
    .to eq(1)
end

Given(/^I visit the "([^"]*)" page for "([^"]*)" "([^"]*)"$/) do |action, object_title, object|
  instance = object.camelize.constantize.find_by(title: object_title)
  path = action.downcase + "_" + object + "_path"
  visit self.send(path.to_sym, instance)
end

Then(/^Youtube URL is posted in slack but not hangout URL when Youtube URL is edited$/) do
  expect(SlackService).not_to receive :post_hangout_notification
  expect(SlackService).to receive(:post_yt_link)

  yt_url = 'https://youtu.be/11111111111'
  event = Event.find_by_name('Scrum')
  visit event_path(event)
  page.execute_script(  %q{$('li[role="edit_yt_link"] > a').trigger('click')}  )
  fill_in 'yt_url', :with => yt_url
  page.find(:css, %q{input[id="yt_link_save"]}).trigger('click')
  visit event_path(event)
end

And(/^that we're spying on the SlackService$/) do
  allow(SlackService).to receive :post_yt_link
  allow(SlackService).to receive :post_hangout_notification
end

Then(/^the Youtube URL is not posted in Slack$/) do
  expect(SlackService).not_to have_received :post_yt_link
end

And(/^the Hangout URL is posted in Slack$/) do
  expect(SlackService).to have_received :post_hangout_notification
end

And(/^the event "([^"]*)" was last updated at "([^"]*)"$/) do |event_name, date|
  id = Event.where(name: event_name).first[:id]
  EventInstance.where(event_id: id).order("created_at DESC").first.update_attributes(updated_at: date)
end

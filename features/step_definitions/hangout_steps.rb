# frozen_string_literal: true

def set_event_start_date(event_ins, num)
  event_ins.updated_at -= num.minutes
end

Given(/^I navigate to the show page for event "([^"]*)"$/) do |name|
  event = Event.find_by_name(name)
  visit event_path(event)
end

Then(/^I jump to one minute before the end of the event at "([^"]*)"/) do |jump_date|
  Delorean.time_travel_to(Time.parse(jump_date))
end

Then(/^I should (not )?see hangout button$/) do |absent|
  if absent
    expect(page).not_to have_css '#hoa_instructions'
  else
    expect(page).to have_css '#hoa_instructions'
  end
end

Given('the Hangout for event {string} has been started with details:') do |event_name, table|
  ho_details = table.transpose.hashes
  hangout = ho_details[0]

  start_time = hangout['Started at'] ? Time.parse(hangout['Started at']) : Time.now
  update_time = hangout['Updated at'] ? Time.parse(hangout['Updated at']) : start_time
  event = Event.find_by_name(event_name)
  create(:event_instance,
         event_id: event.id,
         hangout_url: hangout['EventInstance link'],
         created: start_time,
         updated_at: update_time,
         hoa_status: 'live',
         youtube_tweet_sent: true)
end

Given(/^the following hangouts exist:$/) do |table|
  table.hashes.each do |hash|
    participants = hash['Participants'] || []
    participants = participants.split(',')

    participants = participants.map do |participant|
      break if participant.empty?

      name = participant.squish
      user = User.find_by_first_name(name)
      gplus_id = user.authentications.find_by(provider: 'gplus').try!(:uid) if user.present?
      ['0', { 'person' => { displayName: name.to_s, 'id' => gplus_id } }]
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

Then(/^I have Slack notifications enabled$/) do
  stub_request(:post, 'https://agile-bot.herokuapp.com/hubot/hangouts-notify').to_return(status: 200)
end

Given(/^(\d+) hangouts exists$/) do |count|
  count.to_i.times { FactoryBot.create :event_instance }
end

Then(/^I should see (\d+) hangouts$/) do |count|
  expect(page).to have_css('.hangout', count: count.to_i)
end

When(/^I scroll to bottom of page$/) do
  page.evaluate_script('window.scrollTo(0, $(document).height());')
  sleep 2
end

And(/^there should be three snapshots$/) do
  @hangout.reload
  expect(@hangout.hangout_participants_snapshots.count).to eq 3
end

And(/^the following event instances \(with default participants\) exist:$/) do |table|
  participants = { '0' =>
     { 'id' => 'hangout2750757B_ephemeral.id.google.com^a85dcb4670',
       'hasMicrophone' => 'true',
       'hasCamera' => 'true',
       'hasAppEnabled' => 'true',
       'isBroadcaster' => 'true',
       'isInBroadcast' => 'true',
       'displayIndex' => '0',
       'person' => { 'id' =>
        '108533475599002820142',
                     'displayName' => 'Alejandro Babio',
                     'image' => { 'url' => 'https://lh4.googleusercontent.com/-p4ahDFi9my0/AAAAAAAAAAI/AAAAAAAAAAA/n-WK7pTcJa0/s96-c/photo.jpg' },
                     'na' => 'false' },
       'locale' => 'en',
       'na' => 'false' } }

  table.hashes.each do |hash|
    hash[:event] = Event.find_by name: hash[:event]
    hash[:project] = Project.find_by title: hash[:project]
    hash[:participants] = participants
    create(:event_instance, hash)
  end
end

Then(/^there should be exactly (\d+) hangouts$/) do |number|
  expect(EventInstance.count).to eq number.to_i
end

Then(/^there should be exactly (\d+) hangouts associated with "([^"]*)"$/) do |number, project|
  project = Project.find_by(title: project)
  expect(EventInstance.where(project: project).count).to eq number.to_i
end

Given('a hangout link was set for event {string} {int} minutes ago') do |name, num|
  @hangout_url = 'https://streamyard.com/35mRYwG5vr'
  uid = '865600-888b0a67-ae31-4ecc-a9fa-5617792959d4'
  event = Event.find_by_name(name)
  event_ins = EventInstance.create(uid: uid,
                                   event_id: event.id,
                                   hangout_url: @hangout_url,
                                   url_set_directly: true)
  set_event_start_date(event_ins, num)
  event_ins.save!
end

And(/^I manually set a hangout link for event "([^"]*)"$/) do |name|
  @hangout_url = 'https://hangouts.google.com/hangouts/_/ytl/HEuWPSol0vcSmwrkLzR4Wy4mkrNxNUxVmqHMmCIjEZ8=?hl=en_US&authuser=0'
  event = Event.find_by_name(name)
  visit event_path(event)
  page.execute_script(%q{$('li[role="edit_hoa_link"] > a').trigger('click')})
  fill_in 'hangout_url', with: @hangout_url
  page.find(:css, 'input[id="hoa_link_save"]').trigger('click')
  expect(page).to have_css('.btn-success')
end

Then('{string} shows a live hangout link at start of event') do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).to have_link('JOIN THIS LIVE EVENT NOW', href: @hangout_url)
end

Then('{string} shows a live hangout link near the end of the event') do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).to have_link('JOIN THIS LIVE EVENT NOW', href: @hangout_url)
end

Then('{string} does NOT show a live hangout link after the event ends') do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).not_to have_link('JOIN THIS LIVE EVENT NOW')
end

Given(/^"([^"]*)" doesn't go live$/) do |event_name|
  event = Event.find_by_name(event_name)
  visit event_path(event)
  expect(page).not_to have_link('JOIN THIS LIVE EVENT NOW')
end

Then(/^it should not go live the next day just because the event start time is passed$/) do
  steps %(
    Given the date is "2014 Feb 5th 7:05am"
    Then "Repeat Scrum" doesn't go live
  )
end

Then(/^"([^"]*)" shows youtube link with youtube id "([^"]*)"$/) do |event_name, yt_id|
  yt_url = "https://youtu.be/#{yt_id}"
  visit event_path(Event.find_by_name(event_name))
  page.find(:css, '#actions-dropdown').trigger('click')
  page.find_link('Edit youtube link').trigger('click')
  expect(page).to have_field('yt_url', with: yt_url)
end

Given(/^I manually set youtube link with youtube id "([^"]*)" for event "([^"]*)"$/) do |yt_id, event_name|
  yt_url = "https://youtu.be/#{yt_id}"
  event = Event.find_by_name(event_name)
  visit event_path(event)
  page.execute_script(%q{$('li[role="edit_yt_link"] > a').trigger('click')})
  fill_in 'yt_url', with: yt_url
  page.find(:css, 'input[id="yt_link_save"]').trigger('click')
  find_by_id(yt_id)
end

Then(/^I should see video with youtube id "([^"]*)"$/) do |yt_id|
  expect(page.find(:css, '#ytplayer')[:src]).to include "www.youtube.com/embed/#{yt_id}"
end

Then(/^Hangout link does not change for "([^"]*)"$/) do |event_name|
  visit event_path(Event.find_by_name(event_name))
  page.execute_script(%q{$('li[role="edit_hoa_link"] > a').trigger('click')})
  page.should have_field('hangout_url', with: @hangout_url)
end

Then(/^a separate event instance is not created$/) do
  expect(EventInstance.where('created_at >= ?', Time.now.beginning_of_day).size)
    .to eq(1)
end

Given(/^I visit the "([^"]*)" page for "([^"]*)" "([^"]*)"$/) do |action, object_title, object|
  instance = object.camelize.constantize.find_by(title: object_title)
  path = "#{action.downcase}_#{object}_path"
  visit send(path.to_sym, instance)
end

When(/^I manually edit the Youtube URL$/) do
  yt_url = 'https://youtu.be/11111111111'
  event = Event.find_by_name('Scrum')
  visit event_path(event)
  page.execute_script(%q{$('li[role="edit_yt_link"] > a').trigger('click')})
  fill_in 'yt_url', with: yt_url
  page.find(:css, 'input[id="yt_link_save"]').trigger('click')
  find_by_id('11111111111')
end

Then(/^the Youtube URL is posted in Slack$/) do
  sleep 1
  expect(@slack_client).to have_received :chat_postMessage
end

Then(/^the Hangout URL is not posted in Slack$/) do
  expect(@slack_client).not_to have_received :chat_postMessage
end

Then(/^the Youtube URL is not posted in Slack$/) do
  sleep 1
  expect(@slack_client).not_to have_received :chat_postMessage
end

And(/^that we're spying on the SlackService$/) do
  @slack_client = double(Slack::Web::Client)
  allow(Slack::Web::Client).to receive(:new).and_return(@slack_client)
  allow(@slack_client).to receive(:chat_postMessage)
end

And(/^the Hangout URL is posted in Slack$/) do
  expect(@slack_client).to have_received(:chat_postMessage).twice
end

Then(/^the Hangout URL is posted only in appropriate private channels in Slack$/) do
  expect(@slack_client).to have_received(:chat_postMessage).twice
end

Then(/^the Youtube URL is posted in select private channels in Slack$/) do
  sleep 1
  expect(@slack_client).to have_received(:chat_postMessage).once
end

And(/^the event "([^"]*)" was last updated at "([^"]*)"$/) do |event_name, date|
  id = Event.where(name: event_name).first[:id]
  EventInstance.where(event_id: id).order('created_at DESC').first.update(updated_at: date)
end

Given(/^the Slack notifications are enabled$/) do
  Features.slack.notifications.enabled = true
end

# frozen_string_literal: true

Given(/my YouTube channel is connected/) do
  step 'user "me" has YouTube Channel connected'
end

Then(/I should( not)? see a list of my videos/) do |negative|
  correct_number = [EventInstance.where(user: @current_user).count, 5].min
  video_links = page.all(:css, '.yt_link')
  if negative
    expect(video_links.size).to eq(0)
  else
    expect(video_links.size).to eq(correct_number)
  end
end

Given(/^user "([^"]*)" has YouTube Channel connected/) do |user|
  user = user == 'me' ? @current_user : User.find_by_first_name(user)
  user.youtube_id = 'test_id'
  user.youtube_user_name = 'John Doe'
  user.save!
end

Then(/^I should see video "([^"]*)" in "player"$/) do |name|
  id = find_link(name)[:id]
  expect(page.find(:css, '#ytplayer')[:src]).to include "www.youtube.com/embed/#{id}"
end

Then(/^I should see "([^"]*)" before "([^"]*)"$/) do |title_1, title_2|
  expect(page.body).to match(/#{title_1}.*#{title_2}/m)
end

Given(/^I have some videos on project "(.*?)"$/) do |project|
  step %(the project "#{project}" has 3 videos of user "me")
end

Given(/^the project "(.*?)" has (\d+) videos of user "(.*?)"$/) do |project_title, count, user_name|
  project = Project.find_by(title: project_title)
  names = user_name.split
  user = (user_name == 'me') && @current_user
  user ||= User.find_by first_name: names[0], last_name: names[1]
  user ||= FactoryBot.create :user, first_name: names[0], last_name: names[1]
  count.to_i.times do |n|
    FactoryBot.create :event_instance, title: "PP on #{project_title} - feature: #{n}",
                                       project: project, user: user, created_at: Time.new('2014', '04', '15').utc.beginning_of_day + n.minutes,
                                       youtube_tweet_sent: false
  end
end

Given(/^there is a dud video for project "([^"]*)"$/) do |project_title|
  project = Project.find_by(title: project_title)
  EventInstance.create title: "PP on #{project_title} - feature: cool",
                       project: project, user: User.first, created_at: Time.new('2014', '04', '15').utc.beginning_of_day,
                       yt_video_id: ''
end

Given(/^there are no videos$/) do
  # No videos created
end

Given(/^the live stream has not started$/) do
  mock = {}
  results = {}
  mock.stub_chain(:live_streaming_details, :first).and_return(results)
  expect(results).to receive(:try).with(:actual_start_time).at_most(1).times.and_return(nil)
  expect(Yt::Video).to receive(:new).at_most(1).times.with(id: '11').and_return mock
end

Given(/^the live stream has started$/) do
  mock = {}
  results = {}
  mock.stub_chain(:live_streaming_details, :first).and_return(results)
  expect(results).to receive(:try).with(:actual_start_time).at_most(1).times.and_return(Time.now)
  expect(Yt::Video).to receive(:new).at_most(1).times.with(id: '11').and_return mock
end

Then(/^the event instance will be marked tweet sent$/) do
  ei = EventInstance.find_by(yt_video_id: 11)
  if Settings.features.twitter.notifications.enabled == true
    expect(ei.youtube_tweet_sent).to eq(true)
  else
    expect(ei.youtube_tweet_sent).not_to eq(true)
  end
end

Then(/I should( not)? see a link to watch the event's past video/) do |negate|
  if negate
    expect(page).to have_no_css('#video_links')
  else
    within('#video_links') do
      expect(page).to have_css('a', count: 1)
    end
  end
end

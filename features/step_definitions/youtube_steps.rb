Given /my YouTube channel is connected/ do
  step 'user "me" has YouTube Channel connected'
end

Given /^my YouTube Channel is not connected/ do
  step 'user "me" has YouTube Channel not connected'
end

Then /I should( not)? see a list of my videos/ do |negative|
  correct_number = [ EventInstance.where(user: @current_user).count, 5 ].min
  video_links = page.all(:css, '.yt_link')
  if negative
    expect(video_links).to have(0).items
  else
    expect(video_links).to have(correct_number).items
  end
end

Given /^user "([^"]*)" has YouTube Channel connected/ do |user|
  user = (user == 'me') ? @current_user : User.find_by_first_name(user)
  user.youtube_id = 'test_id'
  user.youtube_user_name = 'John Doe'
  user.save!
end

Given /^user "([^"]*)" has YouTube Channel not connected/ do |user|
  user = (user == 'me') ? @current_user : User.find_by_first_name(user)
  user.youtube_id = nil
  user.save!

  stub_request(:get, /youtube.*title/).to_return(body: '{"entry":{"title":{"$t":"John Doe"}}}')
  stub_request(:get, /googleapis/).to_return(body: '{ "items": [{"id": "test_id"}]}')
end

Then /^I should see video "([^"]*)" in "player"$/ do |name|
  id = find_link(name)[:id]
  expect(page.find(:css, '#ytplayer')[:src]).to match /#{id}/
end

Then /^I should see "([^"]*)" before "([^"]*)"$/ do |title_1, title_2|
  expect(page.body).to match(/#{title_1}.*#{title_2}/m)
end

Given(/^I have some videos on project "(.*?)"$/) do |project|
  step %Q{the project "#{project}" has 3 videos of user "me"}
end

Given(/^the project "(.*?)" has (\d+) videos of user "(.*?)"$/) do |project_title, count, user_name|
  project = Project.find_by(title: project_title)
  names = user_name.split
  user = (user_name == 'me') && @current_user
  user ||= User.find_by first_name: names[0], last_name: names[1]
  user ||= FactoryGirl.create :user, first_name: names[0], last_name: names[1]
  count.to_i.times do |n|
    FactoryGirl.create :event_instance, title: "PP on #{project_title} - feature: #{n}",
      project: project, user: user, created_at: Time.new('2014', '04', '15').utc.beginning_of_day + n.minutes
  end
end

Given /^there are no videos$/ do
  # No videos created
end

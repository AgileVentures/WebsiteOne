Given /^my YouTube Channel ID with (some|no) videos in it/ do |qty|
  step %Q{user "me" has YouTube Channel ID with #{qty} videos in it}
end

Given /my YouTube channel is connected/ do
  step 'user "me" has YouTube Channel connected'
end


Given /^my YouTube Channel is not connected/ do
  step 'user "me" has YouTube Channel not connected'
end


Then /I should( not)? see a list of my videos/ do |negative|
  correct_number = [ YoutubeVideos.send(:parse_response, @user_youtube_response).count, 5 ].min if @user_youtube_response
  video_links = page.all(:css, '.yt_link')
  if negative
    expect(video_links).to have(0).items
  else
    expect(video_links).to have(correct_number).items
  end
end

Given /^user "(?:[^"]*)" has YouTube Channel ID with (some|no) videos in it/ do |qty|
  #TODO YA check what the real response would be for no videos
  @user_youtube_response = (qty == 'some') ? File.read('spec/fixtures/youtube_user_response.json') : nil
  @user_youtube_filtered_response = (qty == 'some') ? File.read('spec/fixtures/youtube_user_filtered_response.json') : nil
end

Given /^user "([^"]*)" has YouTube Channel connected/ do |user|
  user = (user == 'me') ? @current_user : User.find_by_first_name(user)
  user.youtube_id = 'test_id'
  user.youtube_user_name = 'John Doe'
  user.save!

  stub_request(:get, /youtube.*(videos|uploads)/).to_return(body: @user_youtube_response)
  stub_request(:get, /youtube.*WSO|WebsiteOne/i).to_return(body: @user_youtube_filtered_response)
end

Given /^user "([^"]*)" has YouTube Channel not connected/ do |user|
  user = (user == 'me') ? @current_user : User.find_by_first_name(user)
  user.youtube_id = nil
  user.save!

  stub_request(:get, /youtube.*title/).to_return(body: '{"entry":{"title":{"$t":"John Doe"}}}')
  stub_request(:get, /googleapis/).to_return(body: '{ "items": [{"id": "test_id"}]}')
  stub_request(:get, /youtube.*(videos|uploads)/).to_return(body: @user_youtube_response)
end

Then /^I should see video "([^"]*)" in "player"$/ do |name|
  id = find_link(name)[:id]
  expect(page.find(:css, '#ytplayer')[:src]).to match /#{id}/
end


Then /^I should see "([^"]*)" before "([^"]*)"$/ do |title_1, title_2|
  expect(page.body).to match(/#{title_1}.*#{title_2}/m)
end


Given /^there are no videos$/ do
  stub_request(:get, /youtube/).to_return(body: '')
end

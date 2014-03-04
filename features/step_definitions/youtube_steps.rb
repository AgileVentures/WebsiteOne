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
  correct_number = Youtube.parse_response(@user_youtube_response, nil).count if @user_youtube_response
  video_links = page.all(:css, '.yt_link')
  if negative
    expect(video_links).to have(0).items
  else
    expect(video_links).to have(correct_number).items
  end
end

Given /^user "([^"]*)" has YouTube Channel ID with (some|no) videos in it/ do |user, qty|
  #TODO YA check what the real response would be for no videos
  @user_youtube_response = (qty == 'some') ? File.read('spec/fixtures/youtube_user_response.json') : nil
end

Given /^user "([^"]*)" has YouTube Channel connected/ do |user|
  user = user == 'me' ? @current_user : User.find_by_first_name(user)
  user.youtube_id = 'test_id'
  user.save

  request = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json'
  request += '&q=' + @tags.sort.join('%7C') if @tags
  stub_request(:get, request).to_return(body: @user_youtube_response)
end

Given /^user "([^"]*)" has YouTube Channel not connected/ do |user|
  user = user == 'me' ? @current_user : User.find_by_first_name(user)
  user.youtube_id = nil
  user.save

  channel_id_response = File.read('spec/fixtures/youtube_channel_response.json')
  stub_request(:get, 'https://www.googleapis.com/youtube/v3/channels?access_token=test_token&mine=true&part=id').to_return(body: channel_id_response)
  stub_request(:get, 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json').to_return(body: @user_youtube_response)
end

Then /^I should see video "([^"]*)" in "player"$/ do |name|
  id = find_link(name)[:id]
  expect(page.find(:css, '#ytplayer')[:src]).to match /#{id}/
end


Given /^the following project video tags exist:$/ do |table|
  @tags = table.hashes.map { |hash| hash[:tag] }
  FactoryGirl.create(:project_with_tags, tags: @tags)

  response = Youtube.parse_response(@user_youtube_response)
  response.select! do |video|
    @tags.any? { |tag| (video[:title] =~ /#{tag}/) || (video[:content] =~ /#{tag}/) }
  end
  Youtube.stub(parse_response: response)
end

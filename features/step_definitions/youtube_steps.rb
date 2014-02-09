Given /^user "([^"]*)" has YouTube Channel ID "([^"]*)" with some videos in it/ do |user, account_id|
  @user_youtube_id = account_id
  @youtube_user_response = File.read('spec/fixtures/youtube_user_response.json')

  stub_request(:any, 'gdata.youtube.com').to_return(body: @youtube_user_response_xml)
end

Then /I should see a list of videos for user "([^"]*)"/ do |user|
  correct_number = Youtube.parse_response(@youtube_user_response).count
  video_links = page.all(:css, '.yt_link')
  expect(video_links).to have(correct_number).items
end


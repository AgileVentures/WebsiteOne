Given(/^a hangout$/) do
  @hangout = EventInstance.find_by title: 'HangoutsFlow'
end



And(/^that the HangoutConnection has pinged to indicate the hangout is live$/) do
  participants = {"0"=>{"id"=>"hangout2750757B_ephemeral.id.google.com^a85dcb4670", "hasMicrophone"=>"true", "hasCamera"=>"true", "hasAppEnabled"=>"true", "isBroadcaster"=>"true", "isInBroadcast"=>"true", "displayIndex"=>"0", "person"=>{"id"=>"108533475599002820142", "displayName"=>"Alejandro Babio", "image"=>{"url"=>"https://lh4.googleusercontent.com/-p4ahDFi9my0/AAAAAAAAAAI/AAAAAAAAAAA/n-WK7pTcJa0/s96-c/photo.jpg"}, "na"=>"false"}, "locale"=>"en", "na"=>"false"}}
  header 'ORIGIN', 'a-hangout-opensocial.googleusercontent.com'
  put "/hangouts/#{@hangout.uid}", {title: @hangout.title, host_id: '3', event_id: '',
                               participants: participants, hangout_url: 'http://hangout.test',
                               hoa_status: 'live', project_id: '1', category: 'PairProgramming',
                               yt_video_id: '11'}
end

Then(/^the host should be a participant$/) do
  @hangout.reload
  expect(@hangout.participants.values.any?{|struc| struc['person']['displayName'] == 'Alejandro Babio'}).to be true
end

Given(/^that another person joins the hangout$/) do
  pending
end

Then(/^the hangout participants should be updated$/) do
  pending
end

When(/^one person leaves and another joins$/) do
  pending
end

Then(/^the hangout participants should still include everyone who ever joined$/) do
  pending
end
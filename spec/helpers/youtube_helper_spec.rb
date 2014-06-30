require 'spec_helper'

describe YoutubeHelper, :type => :helper do
  it 'retrieves channel ID for logged in user' do
    request_string = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true"
    json = '{ "items": [{"id": "id"}] }'
    WebMock.stub_request(:get, request_string).to_return(body: json)

    expect(helper.channel_id('token')).to eq('id')
  end

 it 'retrieves youtube user_name for a user' do
    user = double(User, youtube_id: 'test_id')
    request_string = "https://gdata.youtube.com/feeds/api/users/test_id?fields=title&alt=json"
    json = '{ "entry": { "title": { "$t": "Ivan Petrov" } } }'
    WebMock.stub_request(:get, request_string).to_return(body: json)

    expect(helper.youtube_user_name(user)).to eq('Ivan Petrov')
  end
end

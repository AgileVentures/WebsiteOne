require 'spec_helper'

describe YoutubeHelper do
  it 'retrieves channel ID for logged in user' do
    request_string = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'items' => [{ 'id' => 'id' }] }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(helper.channel_id('token')).to eq('id')
  end

  it 'retrieves youtube user_id for logged in user' do
    request_string = "https://gdata.youtube.com/feeds/api/users/default?alt=json"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'entry' => { 'yt$username' => { '$t' => 'id' } } }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(helper.user_id('token')).to eq('id')
  end

  it 'retrieves youtube user_name for a user' do
    user = double(User, youtube_id: 'test_id')
    request_string = "https://gdata.youtube.com/feeds/api/users/test_id?fields=title&alt=json"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'entry' => { 'title' => { '$t' => 'Ivan Petrov' } } }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(helper.user_name(user)).to eq('Ivan Petrov')
  end
end

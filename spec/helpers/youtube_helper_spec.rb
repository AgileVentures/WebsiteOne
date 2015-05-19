require 'spec_helper'

describe YoutubeHelper, :type => :helper do
  describe '.channel_id' do
    before do
      request_string = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true"
      json = '{ "items": [{"id": "id"}] }'
      WebMock.stub_request(:get, request_string).to_return(body: json)
    end

    it 'retrieves for logged in user' do
      expect(helper.channel_id('token')).to eq('id')
     end

     it 're-raises error with proper message when invalid json is returned' do
       allow(JSON).to receive(:load).and_raise(JSON::ParserError)
       expect { helper.channel_id('token') }.to raise_error(JSON::ParserError, 'Invalid JSON returned from Youtube')
     end
   end

   describe '.youtube_user_name' do
     let(:user) { User.new(youtube_id: 'test_id') }

     before do
       request_string = "https://gdata.youtube.com/feeds/api/users/test_id?fields=title&alt=json"
       json = '{ "entry": { "title": { "$t": "Ivan Petrov" } } }'
       WebMock.stub_request(:get, request_string).to_return(body: json)
     end

     it 'retrieves youtube user_name for a user' do
       expect(helper.youtube_user_name(user)).to eq('Ivan Petrov')
     end

     it 're-raises error with proper message when invalid json is returned' do
       allow(JSON).to receive(:load).and_raise(JSON::ParserError)
       expect { helper.youtube_user_name(user) }.to raise_error(JSON::ParserError, 'Invalid JSON returned from Youtube')
     end
   end

  it 'creates a "link to youtube" button' do
    link = '/auth/gplus/?youtube=true&amp;origin=video_url'
    expect(helper.link_to_youtube_button('video_url')).to include(link)
  end

  it 'creates an "unlink from youtube" button' do
    link = '/auth/destroy/youtube?origin=video_url'
    expect(helper.unlink_from_youtube_button('video_url')).to include(link)
  end
end

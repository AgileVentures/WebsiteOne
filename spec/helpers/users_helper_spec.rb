require 'spec_helper'


describe UsersHelper do
  describe '#user_display_name' do
    it 'should return the first part of the users email when first name and last name are empty' do
      user = mock_model(User, email: 'jsimp@work.co.uk')
      result = helper.user_display_name(user)
      expect(result).to eq "jsimp"
    end

    it 'should return John when first name is John and last name is empty' do
      user = mock_model(User, first_name: 'John')
      result = helper.user_display_name(user)
      expect(result).to eq "John"
    end

    it 'should return Simpson when first name is empty and last name is Simpson' do
      user = mock_model(User, last_name: 'Simpson')
      result = helper.user_display_name(user)
      expect(result).to eq "Simpson"
    end

    it 'should return Test User when first name is Test and last name is User' do
      user = FactoryGirl.build(:user)
      result = helper.user_display_name(user)
      expect(result).to eq "Test User"
    end
  end
end

describe 'Youtube helpers' do

  it 'retrieves videos from youtube' do
    user = double(User, youtube_id: 'test_id')
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json'
    WebMock.stub_request(:get, request_string).to_return(body: 'response')

    expect(Youtube).to receive(:parse_response).with('response', user)
    Youtube.user_videos(user)
  end

  it 'filters videos by project tags' do
    user = double(User, youtube_id: 'test_id')
    tags = ['London', 'Paris']
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&q=London%7CParis'
    WebMock.stub_request(:get, request_string).to_return(body: 'response')

    expect(Youtube).to receive(:parse_response).with('response', user)
    Youtube.user_videos(user, tags)
  end

  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :id => "VT-efv6jhuk",
             :published => 'Mon, 03 Feb 2014'.to_date,
             :title => "Autograders - Pairing session",
             :content => "Working in HW repo",
             :url => "https://www.youtube.com/watch?v=VT-efv6jhuk&feature=youtube_gdata",
             :thumbs => [{ "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/0.jpg", "height" => 360, "width" => 480, "time" => "01:22:56" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/1.jpg", "height" => 90, "width" => 120, "time" => "00:41:28" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/2.jpg", "height" => 90, "width" => 120, "time" => "01:22:56" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/3.jpg", "height" => 90, "width" => 120, "time" => "02:04:24" }],
             :player_url => "https://www.youtube.com/watch?v=VT-efv6jhuk&feature=youtube_gdata_player",
             :user => "user" }
    expect(Youtube.parse_response(response, 'user').first).to eq(hash)
  end

  it 'retrieves channel ID for logged in user' do
    request_string = "https://www.googleapis.com/youtube/v3/channels?access_token=token&part=id&mine=true"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'items' => [{ 'id' => 'id' }] }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(Youtube.channel_id('token')).to eq('id')
  end

  it 'retrieves youtube user_id for logged in user' do
    request_string = "https://gdata.youtube.com/feeds/api/users/default?access_token=token&alt=json"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'entry' => { 'yt$username' => { '$t' => 'id' } } }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(Youtube.user_id('token')).to eq('id')
  end

  it 'creates a "link to youtube" button' do
    link = '/auth/gplus/?youtube=true&amp;origin=video_url'
    expect(helper.link_to_youtube_button('video_url')).to include(link)
  end

  it 'creates an "unlink from youtube" button' do
    link = '/auth/destroy/0?youtube=true&amp;origin=video_url'
    expect(helper.unlink_from_youtube_button('video_url')).to include(link)
  end

  it 'creates a link to video' do
    video = { title: 'title', url: 'video_url', id: 'id_1', content: 'description' }
    link_attr = %w{class="yt_link" data-content="description" href="video_url" id="id_1" title}
    expect(helper.video_link(video)).to include(*link_attr)
  end

  it 'creates a link to youtube player' do
    video = { id: 'id_1' }
    link = "http://www.youtube.com/embed/id_1?enablejsapi=1"
    expect(helper.video_embed_link(video)).to eq(link)
  end

end

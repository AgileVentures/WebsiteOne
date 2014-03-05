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

  it 'retrieves user videos from youtube' do
    user = double(User, youtube_id: 'test_id', following_by_type: nil)
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&start-index='

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.user_videos(user)
  end

  it 'filters user videos by followed project tags' do
    project_1 = double(Project, title: 'Big Boom', tag_list: ['Big', 'Boom', 'Bang'])
    project_2 = double(Project, title: 'Black hole', tag_list: [])
    user = double(User, youtube_id: 'test_id', following_by_type: [project_1, project_2])

    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&q=Big|Boom|Bang|Black hole&start-index='

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.user_videos(user)
  end

  it 'retrieves project videos from youtube filtering by tags and members' do
    project = double(Project, title: 'Big Boom', tag_list: ['Big', 'Boom', 'Bang'])
    members = [double(User, youtube_user_name: 'John Doe'), double(User, youtube_user_name: 'Ivan Petrov')]
    request_string = %Q{http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&q=Big|Boom|Bang&fields=link,entry[author/name='John Doe' or author/name='Ivan Petrov'](author,id,published,title,content,link,media:group)&start-index=}

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.project_videos(project, members)
  end

  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :author => "Yaro Apletov",
             :id => "VT-efv6jhuk",
             :published => 'Mon, 03 Feb 2014'.to_date,
             :title => "Autograders - Pairing session",
             :content => "Working in HW repo",
             :url => "https://www.youtube.com/watch?v=VT-efv6jhuk&feature=youtube_gdata",
             :thumbs => [{ "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/0.jpg", "height" => 360, "width" => 480, "time" => "01:22:56" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/1.jpg", "height" => 90, "width" => 120, "time" => "00:41:28" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/2.jpg", "height" => 90, "width" => 120, "time" => "01:22:56" }, { "url" => "https://i1.ytimg.com/vi/VT-efv6jhuk/3.jpg", "height" => 90, "width" => 120, "time" => "02:04:24" }],
             :player_url => "https://www.youtube.com/watch?v=VT-efv6jhuk&feature=youtube_gdata_player"
    }
    expect(Youtube.parse_response(response).first).to eq(hash)
  end

  it 'retrieves more than max limit of 50 videos' do
    request = URI.escape('https://gdata.youtube.com/request&start-index=')

    WebMock.stub_request(:get, request + '1').to_return(body: 'response_1')
    WebMock.stub_request(:get, request + '51').to_return(body: 'response_2')

    expect(Youtube).to receive(:parse_response).with('response_1').and_return([])
    expect(Youtube).to receive(:parse_response).with('response_2')

    Youtube.get_response(request)
  end

  it 'sorts videos by published date' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    videos = Youtube.parse_response(response)
    titles = videos.map { |video| video[:title] }
    expect(titles.index('PP on WSO')).to be < titles.index('WebsiteOne - Pairing session')
  end

  it 'retrieves channel ID for logged in user' do
    request_string = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'items' => [{ 'id' => 'id' }] }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(Youtube.channel_id('token')).to eq('id')
  end

  it 'retrieves youtube user_id for logged in user' do
    request_string = "https://gdata.youtube.com/feeds/api/users/default?alt=json"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'entry' => { 'yt$username' => { '$t' => 'id' } } }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(Youtube.user_id('token')).to eq('id')
  end

  it 'retrieves youtube user_name for a user' do
    user = double(User, youtube_id: 'test_id')
    request_string = "https://gdata.youtube.com/feeds/api/users/test_id?fields=title&alt=json"
    WebMock.stub_request(:get, request_string).to_return(body: 'response')
    json = { 'entry' => { 'title' => { '$t' => 'Ivan Petrov' } } }

    expect(JSON).to receive(:load).with('response').and_return(json)
    expect(Youtube.user_name(user)).to eq('Ivan Petrov')
  end

  it 'creates a "link to youtube" button' do
    link = '/auth/gplus/?youtube=true&amp;origin=video_url'
    expect(helper.link_to_youtube_button('video_url')).to include(link)
  end

  it 'creates an "unlink from youtube" button' do
    link = '/auth/destroy/youtube?origin=video_url'
    expect(helper.unlink_from_youtube_button('video_url')).to include(link)
  end

  it 'creates a link to video' do
    video = { title: 'title', url: 'video_url', id: 'id_1', content: 'description' }
    link_attr = %w{class="yt_link" data-content="description" href="video_url" id="id_1" title}
    expect(helper.video_link(video)).to include(*link_attr)
  end

  it 'creates a link to youtube player' do
    video = { id: 'id_1' }
    link = 'http://www.youtube.com/embed/id_1?enablejsapi=1'
    expect(helper.video_embed_link(video)).to eq(link)
  end

end

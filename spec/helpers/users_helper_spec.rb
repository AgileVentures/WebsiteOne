require 'spec_helper'


describe UsersHelper do
end

describe 'Youtube helpers' do

  it 'retrieves user videos from youtube' do
    user = double(User, youtube_id: 'test_id', youtube_user_name: 'test_name')
    Youtube.stub(followed_project_tags: ['WSO'])
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.user_videos(user)
  end

  it 'filters user videos by followed project tags' do
    project_1 = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    project_2 = double(Project, title: 'Black hole', tag_list: [])
    user = double(User, youtube_id: 'test_id', following_by_type: [project_1, project_2])

    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.user_videos(user)
  end

  it 'retrieves project videos from youtube filtering by tags and members' do
    project = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    members = [double(User, youtube_user_name: 'John Doe'), double(User, youtube_user_name: 'Ivan Petrov')]
    request_string = %q{http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published&fields=entry(author(name),id,published,title,content,link)&q=("big+regret"|boom|bang|"big+boom")/("john+doe"|"ivan+petrov")}

    expect(Youtube).to receive(:get_response).with(request_string)
    Youtube.project_videos(project, members)
  end

  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :author => "John Doe",
             :id => "3Hi41S5Tp54",
             :published => 'Fri, 14 Feb 2014'.to_date,
             :title => "WebsiteOne - Pairing session - refactoring authentication controller",
             :content => "WebsiteOne - Pairing session - refactoring authentication controller",
             :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata" }
    expect(Youtube.parse_response(response).first).to eq(hash)
  end

  it 'sorts videos by published date' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    videos = Youtube.parse_response(response)
    titles = videos.map { |video| video[:title] }
    expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
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

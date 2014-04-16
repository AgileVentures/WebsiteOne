require 'spec_helper'

describe YoutubeApi do
  it 'retrieves user videos from youtube' do
    user = double(User, youtube_id: 'test_id', youtube_user_name: 'test_name')
    api = YoutubeApi.new(user)
    api.stub(followed_project_tags: ['WSO'])
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(api).to receive(:get_response).with(request_string)
    api.user_videos
  end

  it 'filters user videos by followed project tags' do
    project_1 = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    project_2 = double(Project, title: 'Black hole', tag_list: [])
    user = double(User, youtube_id: 'test_id', following_by_type: [project_1, project_2])
    api = YoutubeApi.new(user)

    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(api).to receive(:get_response).with(request_string)
    api.user_videos
  end

  it 'retrieves project videos from youtube filtering by tags and members' do
    project = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    members = [double(User, youtube_user_name: 'John Doe'), double(User, youtube_user_name: 'Ivan Petrov')]
    api = YoutubeApi.new(project, members)

    request_string = %q{http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published&q=("big+regret"|boom|bang|"big+boom")/("john+doe"|"ivan+petrov")&fields=entry(author(name),id,published,title,content,link)}

    expect(api).to receive(:get_response).with(request_string)
    api.project_videos
  end

  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :author => "John Doe",
             :id => "3Hi41S5Tp54",
             :published => 'Fri, 14 Feb 2014'.to_date,
             :title => "WebsiteOne - Pairing session - refactoring authentication controller",
             :content => "WebsiteOne - Pairing session - refactoring authentication controller",
             :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata" }
    expect(YoutubeApi.new(double(User)).parse_response(response).first).to eq(hash)
  end

  it 'sorts videos by published date' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    videos = YoutubeApi.new(double(User)).parse_response(response)
    titles = videos.map { |video| video[:title] }
    expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
  end

  it 'logs json error and returns nil on parsing invalid json' do
    JSON.stub(:parse).and_raise(JSON::JSONError)
    Rails.logger.should_receive(:warn).with('Attempted to decode invalid JSON')
    YoutubeApi.new(double(User)).parse_response('').should be_nil
  end

  it 'raises ArgumentError if initialized with invalid arguments' do
    expect { YoutubeApi.new("invalid", "invalid", "invalid") }.to raise_error ArgumentError
  end
end
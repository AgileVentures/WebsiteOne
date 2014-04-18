require 'spec_helper'
include YoutubeApi

describe YoutubeApi do
  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :author => "John Doe",
             :id => "3Hi41S5Tp54",
             :published => 'Fri, 14 Feb 2014'.to_date,
             :title => "WebsiteOne - Pairing session - refactoring authentication controller",
             :content => "WebsiteOne - Pairing session - refactoring authentication controller",
             :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata" }
    expect(parse_response(response).first).to eq(hash)
  end

  it 'sorts videos by published date' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'
    stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})
    videos = get_response(request_string)
    titles = videos.map { |video| video[:title] }
    expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
  end

  it 'logs json error and returns nil on parsing invalid json' do
    JSON.stub(:parse).and_raise(JSON::JSONError)
    Rails.logger.should_receive(:warn).with('Attempted to decode invalid JSON')
    parse_response('').should be_nil
  end

  it 'returns project tags for projects with project title and tags and a scrum tag' do
    project_1 = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    project_2 = double(Project, title: 'Black hole', tag_list: [])
    user = double(User, youtube_id: 'test_id', following_by_type: [project_1, project_2])
    followed_project_tags(user).should eq ["big regret", "boom", "bang", "big boom", "black hole", "scrum"]
  end


end
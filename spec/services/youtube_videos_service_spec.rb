require 'spec_helper'

describe YoutubeVideosService do
  subject { YoutubeVideosService.new }

  it 'retrieves user videos from youtube' do
    user = double(User, youtube_id: 'test_id', youtube_user_name: 'test_name')
    subject.stub(followed_project_tags: ['WSO'])
    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(subject).to receive(:get_response).with(request_string)
    subject.user_videos(user)
  end

  it 'filters user videos by followed project tags' do
    project_1 = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    project_2 = double(Project, title: 'Black hole', tag_list: [])
    user = double(User, youtube_id: 'test_id', following_by_type: [project_1, project_2])

    request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

    expect(subject).to receive(:get_response).with(request_string)
    subject.user_videos(user)
  end

  it 'retrieves project videos from youtube filtering by tags and members' do
    project = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
    members = [double(User, youtube_user_name: 'John Doe'), double(User, youtube_user_name: 'Ivan Petrov')]
    request_string = %q{http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published&fields=entry(author(name),id,published,title,content,link)&q=("big+regret"|boom|bang|"big+boom")/("john+doe"|"ivan+petrov")}

    expect(subject).to receive(:get_response).with(request_string)
    subject.project_videos(project, members)
  end

  it 'parses youtube response into an array of hashes' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    hash = { :author => "John Doe",
             :id => "3Hi41S5Tp54",
             :published => 'Fri, 14 Feb 2014'.to_date,
             :title => "WebsiteOne - Pairing session - refactoring authentication controller",
             :content => "WebsiteOne - Pairing session - refactoring authentication controller",
             :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata" }
    expect(subject.parse_response(response).first).to eq(hash)
  end

  it 'sorts videos by published date' do
    response = File.read('spec/fixtures/youtube_user_response.json')
    videos = subject.parse_response(response)
    titles = videos.map { |video| video[:title] }
    expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
  end
end

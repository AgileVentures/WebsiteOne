require 'spec_helper'

describe YoutubeVideos do
  subject { YoutubeVideos }

  describe "for(object)" do
    it 'should call private method :user_videos is object is User' do
      expect(subject).to receive(:user_videos)
      subject.for(User.new)
    end

    it 'should call private method :project_videos is object is Project' do
      expect(subject).to receive(:project_videos)
      subject.for(Project.new)
    end
  end

  # PRIVATE METHODS
  describe "project_videos(object)" do
    it 'returns videos for project by project tags and following members who have youtube connected' do
      users = [
        build_stubbed(:user, youtube_id: 'test_id', youtube_user_name: 'John Doe'),
        build_stubbed(:user, youtube_id: 'test_id_2', youtube_user_name: 'Sampriti Panda'),
      ]
      project = build_stubbed(:project, title: "WebsiteOne", tag_list: ["WSO"])
      allow(project).to receive(:members).and_return([users[0]])

      response = File.read('spec/fixtures/youtube_user_filtered_response.json')
      request_string = 'http://gdata.youtube.com/feeds/api/videos?alt=json&fields=entry(author(name),id,published,title,content,link)&max-results=50&orderby=published&q=(wso|websiteone)/("john doe")'
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = subject.for(project)
      videos.each do |video|
        expect(video[:title]).to match(/(WebsiteOne|WSO)/i)
        expect(video[:author]).to eq "John Doe"
        expect(video[:author]).not_to eq "Sampriti Panda"
      end
    end
  end

  describe "user_videos(object)" do
    it 'returns videos for user sorted by published date and filtered by its projects' do
      project = build_stubbed(:project, title: "WebsiteOne", tag_list: ["WSO"])
      project_2 = build_stubbed(:project, title: "AutoGraders", tag_list: ["AutoGrader"])
      user = build_stubbed(:user, youtube_id: 'test_id', youtube_user_name: 'John Doe')
      allow(user).to receive(:following_by_type).and_return([project])
      response = File.read('spec/fixtures/youtube_user_response.json')
      request_string = "http://gdata.youtube.com/feeds/api/users/#{user.youtube_id}/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)"
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = subject.for(user)
      videos.each do |video|
        expect(video[:title]).to match(/(WebsiteOne|WSO)/i)
        expect(video[:title]).not_to match(/(AutoGraders)/i)
      end
      videos_dates = videos.map { |v| v[:published] }
      expect(videos_dates).to eq videos_dates.sort.reverse
    end
  end

  describe "parse_response(json)" do
    it 'parses youtube response into an array of hashes' do
      response = File.read('spec/fixtures/youtube_user_response.json')
      hash = {:author => "John Doe",
              :id => "3Hi41S5Tp54",
              :published => 'Fri, 14 Feb 2014'.to_date,
              :title => "WebsiteOne - Pairing session - refactoring authentication controller",
              :content => "WebsiteOne - Pairing session - refactoring authentication controller",
              :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata"}
      expect(subject.send(:parse_response, response).first).to eq(hash)
    end

    it 're-raises error with proper message when invalid json is returned' do
      expect { subject.send(:parse_response, '{') }.to raise_error(JSON::ParserError, 'Invalid JSON returned from Youtube')
    end
  end

  describe "build_request_for_project_videos(project)" do
    it 'properly escapes the query params and returns correctly formatted URL' do
      project = Project.new
      allow(project).to receive(:members_tags).and_return(["john doe"])
      allow(project).to receive(:youtube_tags).and_return(["wso", "websiteone"])
      expected_string = "http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published&fields=entry(author(name),id,published,title,content,link)&q=(wso|websiteone)/(\"john+doe\")"

      expect(subject.send(:build_request_for_project_videos, project)).to eq expected_string
    end
  end

  describe "build_request_for_user_videos(user)" do
    it 'properly escapes the query params and returns correctly formatted URL' do
      user = build_stubbed(User, youtube_id: 'test_id')
      expected_string =  'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

      expect(subject.send(:build_request_for_user_videos, user)).to eq expected_string
    end
  end

  describe "escape_query_params(params)" do
    it 'escapes the params array to be used in youtube query' do
      params = ['param1', 'param with spaces', 'param2']
      expect(subject.send(:escape_query_params, params)).to eq "(param1|\"param+with+spaces\"|param2)"
    end
  end

  describe "get_response(url)" do
    it 'sorts videos by published date' do
      response = File.read('spec/fixtures/youtube_user_response.json')
      request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = subject.send(:get_response, request_string)
      titles = videos.map { |video| video[:title] }
      expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
    end
  end

  describe "filter_response(response, tags, members)" do
    it 'filters the response by members and project tags' do
      videos = [
        {title: "WebsiteOne", author: "sampriti"},
        {title: "WebsiteOne", author: "bryan"},
        {title: "WebsiteOne", author: "thomas"},
        {title: "LocalSupport", author: "sampriti"},
        {title: "LocalSupport", author: "abagail"}
      ]
      result = subject.send(:filter_response, videos, ["WebsiteOne"], ["sampriti", "bryan"])
      expect(result).to eq videos[0..1]
    end
  end
end


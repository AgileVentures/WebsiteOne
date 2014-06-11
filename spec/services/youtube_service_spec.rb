require 'spec_helper'

describe YoutubeService do
  subject { YoutubeService }
  let(:mock_service) { subject.new(double) }

  describe '::new' do
    it 'assigns the user to a object instance variable' do
      user = mock_model(User)
      service = subject.new(user)

      expect(service.instance_variable_get("@object")).to eq user
    end
  end

  describe "#videos" do
    it 'should call private method :user_videos is object is User' do
      service = subject.new(mock_model(User))
      expect(service).to receive(:user_videos)

      service.videos
    end

    it 'should call private method :project_videos is object is Project' do
      service = subject.new(mock_model(Project))
      expect(service).to receive(:project_videos)

      service.videos
    end
  end

  # PRIVATE METHODS
  # Integration Tests Start
  describe "#project_videos" do
    it 'returns videos for project by project tags and following members who have youtube connected' do
      users = [
        FactoryGirl.create(:user, youtube_id: 'test_id', youtube_user_name: 'John Doe'),
        FactoryGirl.create(:user, youtube_id: 'test_id_2', youtube_user_name: 'Sampriti Panda'),
      ]
      project = FactoryGirl.create(:project, title: "WebsiteOne", tag_list: ["WSO"])
      project.stub(members: [users[0]])

      response = File.read('spec/fixtures/youtube_user_filtered_response.json')
      request_string = 'http://gdata.youtube.com/feeds/api/videos?alt=json&fields=entry(author(name),id,published,title,content,link)&max-results=50&orderby=published&q=(wso|websiteone)/("john doe")'
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = subject.new(project).videos
      videos.each do |video|
        video[:title].should match(/(WebsiteOne|WSO)/i)
        video[:author].should eq "John Doe"
        video[:author].should_not eq "Sampriti Panda"
      end
    end
  end

  describe "#user_videos" do
    it 'returns videos for user sorted by published date and filtered by its projects' do
      project = FactoryGirl.create(:project, title: "WebsiteOne", tag_list: ["WSO"])
      project_2 = FactoryGirl.create(:project, title: "AutoGraders", tag_list: ["AutoGrader"])
      user = FactoryGirl.create(:user, youtube_id: 'test_id', youtube_user_name: 'John Doe')
      user.stub(following_by_type: [project])
      response = File.read('spec/fixtures/youtube_user_response.json')
      request_string = "http://gdata.youtube.com/feeds/api/users/#{user.youtube_id}/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)"
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = subject.new(user).videos
      videos.each do |video|
        video[:title].should match(/(WebsiteOne|WSO)/i)
        video[:title].should_not match(/(AutoGraders)/i)
      end
      videos_dates = videos.map { |v| v[:published] }
      expect(videos_dates).to eq videos_dates.sort.reverse
    end
  end
  # Integration Tests End
  
  describe "#parse_response" do
    it 'parses youtube response into an array of hashes' do
      response = File.read('spec/fixtures/youtube_user_response.json')
      hash = {:author => "John Doe",
              :id => "3Hi41S5Tp54",
              :published => 'Fri, 14 Feb 2014'.to_date,
              :title => "WebsiteOne - Pairing session - refactoring authentication controller",
              :content => "WebsiteOne - Pairing session - refactoring authentication controller",
              :url => "http://www.youtube.com/watch?v=3Hi41S5Tp54&feature=youtube_gdata"}
      expect(mock_service.send(:parse_response, response).first).to eq(hash)
    end

    it 'logs json error and returns nil on parsing invalid json' do
      JSON.stub(:parse).and_raise(JSON::JSONError)
      Rails.logger.should_receive(:warn).with('Attempted to decode invalid JSON')
      mock_service.send(:parse_response, '').should be_nil
    end
  end

  describe "#build_request_for_project_videos" do
    it 'properly escapes the query params and returns correctly formatted URL' do
      members_tags = ["john doe"]
      projects_tags = ["wso", "websiteone"]
      expected_string = "http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published&q=(wso|websiteone)/(\"john+doe\")&fields=entry(author(name),id,published,title,content,link)"

      expect(mock_service.send(:build_request_for_project_videos, members_tags, projects_tags)).to eq expected_string
    end
  end

  describe "#build_request_for_user_videos" do
    it 'properly escapes the query params and returns correctly formatted URL' do
      user = double(User, youtube_id: 'test_id')
      expected_string =  'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'

      service = subject.new(user)
      expect(service.send(:build_request_for_user_videos)).to eq expected_string
    end
  end

  describe "#project_tags" do
    it 'returns the tags for project including the project title' do
      project = double(Project, title: "WebsiteOne", tag_list: ["WSO"])
      service = subject.new(project)
      expect(service.send(:project_tags)).to eq ["wso", "websiteone"]
    end
  end

  describe "#members_tags" do
    it 'returns the tags for project members with thier youtube user names' do
      users = [double(User, youtube_user_name: 'test_id'), double(User, youtube_user_name: 'test_id_2')]
      project = double(Project, members: users)
      service = subject.new(project)
      expect(service.send(:members_tags)).to eq ["test_id", "test_id_2"]
    end
  end

  describe "#escape_query_params" do
    it 'escapes the params array to be used in youtube query' do
      params = ['param1', 'param with spaces', 'param2']
      expect(mock_service.send(:escape_query_params, params)).to eq "(param1|\"param+with+spaces\"|param2)"
    end
  end

  describe "#get_response" do
    it 'sorts videos by published date' do
      response = File.read('spec/fixtures/youtube_user_response.json')
      request_string = 'http://gdata.youtube.com/feeds/api/users/test_id/uploads?alt=json&max-results=50&fields=entry(author(name),id,published,title,content,link)'
      stub_request(:get, request_string).to_return(status: 200, body: response, headers: {})

      videos = mock_service.send(:get_response, request_string)
      titles = videos.map { |video| video[:title] }
      expect(titles.index('WebsiteOne - Pairing session - refactoring authentication controller')).to be < titles.index('Autograders - Pairing session')
    end
  end

  describe "#followed_project_tags" do
    it 'returns project tags for projects with project title and tags and a scrum tag' do
      project_1 = double(Project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
      project_2 = double(Project, title: 'Black hole', tag_list: [])
      user = double(User, youtube_id: 'test_id', projects_joined: [project_1, project_2])
      service = subject.new(user)
      service.send(:followed_project_tags).should eq ["big regret", "boom", "bang", "big boom", "black hole", "scrum"]
    end
  end

  describe "#filter_response" do
    it 'filters the response by members and project tags' do
      videos = [
        {title: "WebsiteOne", author: "sampriti"},
        {title: "WebsiteOne", author: "bryan"},
        {title: "WebsiteOne", author: "thomas"},
        {title: "LocalSupport", author: "sampriti"},
        {title: "LocalSupport", author: "abagail"}
      ]
      result = mock_service.send(:filter_response, videos, ["WebsiteOne"], ["sampriti", "bryan"])
      expect(result).to eq videos[0..1]
    end
  end
end

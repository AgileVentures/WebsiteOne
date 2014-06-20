require 'spec_helper'

describe YoutubeVideos do
  subject { YoutubeVideos }

  describe "::for" do
    it 'should call private method :user_videos is object is User' do
      expect(subject).to receive(:user_videos)
      subject.for(mock_model(User))
    end

    it 'should call private method :project_videos is object is Project' do
      expect(subject).to receive(:project_videos)
      subject.for(mock_model(Project))
    end
  end

  # PRIVATE METHODS
  # Integration Tests Start
  describe "::project_videos" do
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

      videos = subject.for(project)
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

      videos = subject.for(user)
      videos.each do |video|
        video[:title].should match(/(WebsiteOne|WSO)/i)
        video[:title].should_not match(/(AutoGraders)/i)
      end
      videos_dates = videos.map { |v| v[:published] }
      expect(videos_dates).to eq videos_dates.sort.reverse
    end
  end
  # Integration Tests End
end


require 'spec_helper'

describe YoutubeService do
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
end


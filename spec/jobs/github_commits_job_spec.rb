require 'spec_helper'

describe GithubCommitsJob do
  vcr_index = {cassette_name: 'github_commit_count/websiteone_stats'}

  describe '.job', vcr: vcr_index do
    before do
      @project = FactoryGirl.create(:project, github_url: 'https://github.com/AgileVentures/WebsiteOne')
      @project_with_wrong_protocol = FactoryGirl.create(:project, github_url: 'http://github.com/AgileVentures/WebsiteOne')
      @project_without_url = FactoryGirl.create(:project)
      @users = [
        FactoryGirl.create(:user, github_profile_url: 'https://github.com/yggie'),
        FactoryGirl.create(:user, github_profile_url: 'https://github.com/tochman'),
        FactoryGirl.create(:user, github_profile_url: nil)
      ]
      GithubCommitsJob.run
      @project.reload
      @project_with_wrong_protocol.reload
      @project_without_url.reload
    end

    it 'changes the protocol to https' do
      expect(@project_with_wrong_protocol.github_url).to include('https://')
    end

    it 'stores commit counts only for projects that have a github_url' do
      expect(@project.commit_counts.count).to be > 1
      expect(@project_without_url.commit_counts.count).to eq 0
    end

    it 'stores total commit count only for projects that have a github_url' do
      expect(@project.commit_count).to be > 1
      expect(@project_without_url.commit_count).to eq 0
    end

    it 'stores commit counts only for users that have a github_profile_url' do
      commit_count_users = @project.commit_counts.map(&:user)
      expect(commit_count_users).to_not include(@users[2])
      expect(commit_count_users).to include(@users[0])
      expect(commit_count_users).to include(@users[1])
    end

    it 'stores correct commit counts by user and project' do
      expect(CommitCount.find_by!(project: @project, user: @users[0]).commit_count).to eq 388
      expect(CommitCount.find_by!(project: @project, user: @users[1]).commit_count).to eq 316
    end

    it 'stores correct total commit count for projects' do
      expect(@project.commit_count).to eq 2795
    end
  end
end

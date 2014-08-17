require 'spec_helper'

describe GithubCommitsJob do
  describe '.job' do
    before do
      FactoryGirl.create_list(:project, 9, github_url: nil)
      FactoryGirl.create_list(:project, 3, github_url: 'http://github.com/project')
    end

    it 'updates commit counts for projects that have a github_url' do
      expect(CommitCount).to receive(:update_commit_counts_for).with(an_instance_of(Project)).exactly(3).times
      GithubCommitsJob.run
    end
  end
end

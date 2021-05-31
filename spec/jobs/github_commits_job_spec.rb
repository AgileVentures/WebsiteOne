# frozen_string_literal: true

RSpec.describe GithubCommitsJob do
  vcr_index = { cassette_name: 'github_commit_count/websiteone_stats' }
  describe '.job', vcr: vcr_index do
    context 'when no empty repo present' do
      let(:project) { @project.reload }
      let(:project_without_url) { @project_without_url.reload }
      before do
        @project = create(:project)
        @project_without_url = create(:project)
        @project.source_repositories.create(url: 'https://github.com/AgileVentures/WebsiteOne')
        @users_with_github_profile_urls = [
          create(:user, github_profile_url: 'https://github.com/tochman')
        ]
        @users_without_github_profile_urls = [
          create(:user, github_profile_url: nil)
        ]
        @users = @users_with_github_profile_urls + @users_without_github_profile_urls
        GithubCommitsJob.run
      end

      it 'stores commit counts only for projects that have a github_url' do
        expect(project.commit_counts.count).to eq(1)
        expect(project_without_url.commit_counts.count).to eq 0
      end

      it 'stores total commit count only for projects that have a github_url' do
        expect(project.commit_count).to be > 1
        expect(project_without_url.commit_count).to eq 0
      end

      it 'stores commit counts only for users that have a github_profile_url' do
        expect(project.commit_counts.map(&:user)).to match_array(@users_with_github_profile_urls)
      end

      it 'stores correct commit counts by user and project' do
        expect(CommitCount.find_by!(project: project, user: @users[0]).commit_count).to eq 482
        expect(CommitCount.find_by(project: project, user: @users[1])).to be_nil
      end

      it 'stores correct total commit count for projects' do
        expected_commit_count = 4919
        expect(project.commit_count).to eq expected_commit_count
      end

      it 'stores last_commit_at only for projects that have a github_url' do
        expect(project.updated_at).to be > '2000-01-01'
      end

      # Skipping this test for a couple reasons:
      # 1 - `update_total_commits_for` method does not exist which is why it is failing
      # 2 - IIRC a lot of the GitHub currently does not work, and I think it needs a complete overhaul
      #     if we are going to keep it around.
      # 3 - This test documents that we are catching a StandardError in the code. I think it would be
      # .   better to catch a more specific error related to the external api.
      xit 'executes user_commits method even if total_commits dies for project' do
        allow(GithubCommitsJob).to receive(:update_total_commits_for).and_raise 'StandardError'
        expect(GithubCommitsJob).to receive(:update_user_commit_counts_for).with project
        GithubCommitsJob.run
      end
    end

    context 'when empty project is present' do
      let(:project_with_empty_repo) { @project_with_empty_repo.reload }

      before do
        @project_with_empty_repo = FactoryBot.create(:project, github_url: 'https://github.com/AgileVentures/empty_project')
        GithubCommitsJob.run
      end

      it 'stores commit count for project with empty repo' do
        expect(project_with_empty_repo.commit_counts.count).to eq(0)
      end

      it 'stores total commit count for project with empty repo' do
        expect(project_with_empty_repo.commit_count).to eq(0)
      end
    end
  end
end

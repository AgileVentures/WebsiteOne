# frozen_string_literal: true

RSpec.describe GithubLastUpdatesJob do
  describe '#run' do
    context 'shf-project with hyphen', vcr: true do
      let!(:project) { create(:project) }
      before { project.source_repositories.create(url: 'https://github.com/AgileVentures/shf-project') }
      it 'has correct last commit date after job run' do
        GithubLastUpdatesJob.run
        expect(project.reload.last_github_update).not_to be_nil
      end
    end
  end
end

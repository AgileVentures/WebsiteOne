require 'spec_helper'

describe GithubLastUpdatesJob do
  describe '#run' do
    context 'shf-project with hyphen' do
      let!(:project){FactoryGirl.create(:project, github_url: 'https://github.com/AgileVentures/shf-project')}
      it 'has correct last commit date after job run' do
        GithubLastUpdatesJob.run
        expect(project.reload.last_github_update).not_to be_nil
      end
    end
  end
end

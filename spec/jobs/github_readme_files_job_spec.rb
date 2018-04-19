require 'spec_helper'

describe GithubReadmeFilesJob do
  context 'Update pitch on project' do
    before do
      @project = FactoryBot.create(:project, pitch: nil)
      @project.source_repositories.create(url: 'https://github.com/AgileVentures/LocalSupport')
      @projects = Project.with_github_url
    end

    it 'should have no pitch' do
      expect(@project.pitch).to be nil
    end

    it 'should have pitch setup with README' do
      readme = Octokit.readme 'AgileVentures/LocalSupport', :accept => 'application/vnd.github.html'
      expect { GithubReadmeFilesJob.run(@projects) }.to_not raise_error
      expect(Project.first.pitch).to eq(readme)
    end
  end
end

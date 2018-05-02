require 'spec_helper'

describe GithubReadmeFilesJob do
  vcr_index = { cassette_name: 'github_readme_pitch/github_readme_pitch' }

  describe '.job using readme', vcr: vcr_index do
    context 'Update pitch on project using the README.md file' do
      before do
        @project = FactoryBot.create(:project, pitch: nil)
        @project.source_repositories.create(url: 'https://github.com/AgileVentures/LocalSupport')
        @projects = Project.with_github_url
      end

      it 'should have no pitch' do
        expect(@project.pitch).to be nil
      end

      it 'should have pitch setup with README.md since PITCH.md is not present' do
        readme = Octokit.contents 'AgileVentures/LocalSupport', path: 'README.md', :accept => 'application/vnd.github.html'
        expect { GithubReadmeFilesJob.run(@projects) }.to_not raise_error
        expect(Project.first.pitch).to eq(readme)
      end

      it 'should log the error if the repository does NOT exists' do
        message = 'Trying to get the content from fake/repository have caused the issue!'
        error = ErrorLoggingService.new(StandardError)
        @project.source_repositories.first.update(url: 'https://github.com/fake/repository')
        allow(ErrorLoggingService).to receive(:new).and_return(error)
        expect(error).to receive(:log).with(message)
        GithubReadmeFilesJob.run([@project])
      end
    end

    context 'Update pitch on project using the PITCH.md file' do
      before do
        @project = FactoryBot.create(:project, pitch: nil)
        @project.source_repositories.create(url: 'https://github.com/nisevi/nisevi')
        @projects = Project.with_github_url
      end

      it 'should have no pitch' do
        expect(@project.pitch).to be nil
      end

      it 'should have pitch setup with PITCH.md' do
        pitch = Octokit.contents 'nisevi/nisevi', path: 'PITCH.md', :accept => 'application/vnd.github.html'
        expect { GithubReadmeFilesJob.run(@projects) }.to_not raise_error
        expect(Project.first.pitch).to eq(pitch)
      end
    end
  end
end

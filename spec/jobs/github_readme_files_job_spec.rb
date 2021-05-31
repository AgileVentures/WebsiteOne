# frozen_string_literal: true

RSpec.describe GithubReadmeFilesJob do
  describe '.replace_relative_links_with_absolute' do
    let(:project) { create(:project, pitch: nil) }
    let(:project_readme_content) do
      '<a href="hello">hello</a><a href="http://example.com/hello">hello</a><a href="#hello">hello</a>'
    end

    before do
      project.source_repositories.create(url: 'https://github.com/AgileVentures/LocalSupport')
      @converted_text = subject.replace_relative_links_with_absolute(project_readme_content, project)
    end

    it 'converts all relative urls in text to absolute with full host prefix' do
      converted_link = 'https://github.com/AgileVentures/LocalSupport/blob/master/hello'
      expect(@converted_text).to include converted_link
      expect(@converted_text).to_not include 'href="hello"'
    end

    it 'does not change absolute links' do
      absolute_link = 'http://example.com/hello'
      expect(@converted_text).to include absolute_link
    end

    it 'does not change anchor links' do
      anchor_link = '#hello'
      expect(@converted_text).to include anchor_link
    end
  end

  vcr_index = { cassette_name: 'github_readme_pitch/github_readme_pitch' }

  describe '.job using readme', vcr: vcr_index do
    context 'Update pitch on project using the README.md file' do
      before do
        @project = create(:project, pitch: nil)
        @project.source_repositories.create(url: 'https://github.com/AgileVentures/LocalSupport')
        @projects = Project.with_github_url
      end

      it 'should have no pitch' do
        expect(@project.pitch).to be nil
      end

      it 'should have pitch setup with README.md since PITCH.md is not present' do
        expect { GithubReadmeFilesJob.run(@projects) }.to_not raise_error
        expect(@projects.first.pitch).to_not be nil
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
        @project = create(:project, pitch: nil)
        @project.source_repositories.create(url: 'https://github.com/nisevi/nisevi')
        @projects = Project.with_github_url
      end

      it 'should have no pitch' do
        expect(@project.pitch).to be nil
      end

      it 'should have pitch setup with PITCH.md' do
        pitch = Octokit.contents 'nisevi/nisevi', path: 'PITCH.md', accept: 'application/vnd.github.html'
        expect { GithubReadmeFilesJob.run(@projects) }.to_not raise_error
        expect(Project.first.pitch).to eq(pitch)
      end
    end
  end
end

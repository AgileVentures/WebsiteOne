require 'octokit'
require 'base64'

module GithubReadmeFilesJob
  extend self

  def client
    credentials = {
        client_id: Settings.github.client_id,
        client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run(projects)
    projects.each do |project|
      begin
        project.pitch = content(project.github_repo, 'PITCH.md')
        project.save!
      rescue StandardError => e
        if e.message.include?('404 - Not Found')
          project_readme(project)
        else
          ErrorLoggingService.new(e).log(error_message(project.github_repo))
        end
      end
    end
  end

  private

  def project_readme(project)
    begin
      project.pitch = content(project.github_repo, 'README.md')
      project.save!
    rescue StandardError => e
      ErrorLoggingService.new(e).log(error_message(project.github_repo))
    end
  end

  def error_message(repository)
    "Trying to get the content from #{repository} have caused the issue!"
  end

  def content(repository, path)
    client.contents repository, path: path, accept: 'application/vnd.github.html'
  end
end

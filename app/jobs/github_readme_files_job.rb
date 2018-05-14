# frozen_string_literal: true

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
        project.update(pitch: content(project.github_repo, 'PITCH.md'))
      rescue StandardError => e
        evaluate_exception(e, project)
      end
    end
  end

  private

  def project_readme(project)
    begin
      project.update(pitch: content(project.github_repo, 'README.md'))
    rescue StandardError => e
      log_error(e, project)
    end
  end

  def error_message(repository)
    "Trying to get the content from #{repository} have caused the issue!"
  end

  def content(repository, path)
    client.contents repository, path: path, accept: 'application/vnd.github.html'
  end

  def evaluate_exception(error, project)
    if error.message.include?('404 - Not Found')
      project_readme(project)
    else
      log_error(error, project)
    end
  end

  def log_error(error, project)
    ErrorLoggingService.new(error).log(error_message(project.github_repo))
  end
end

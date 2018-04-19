require 'octokit'
require 'base64'

module GithubReadmeFilesJob
  extend self

  def run(projects)
    projects.each do |project|
      begin
        project.pitch = get_readme(project.github_repo)
        project.save!
      rescue StandardError => e
        ErrorLoggingService.new(e).log("Trying to get the content from #{project.github_repo} have caused the issue!")
      end
    end
  end

  private

  def get_readme(repository)
    Octokit.readme repository, :accept => 'application/vnd.github.html'
  end
end

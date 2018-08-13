require 'octokit'

module GithubLanguagesJob
  extend self

  def run
    Project.with_github_url.each do |p|
      begin
        languages = client.languages("#{p.github_repo_user_name}/#{p.github_repo_name}")
        languages.keys.each { |language| p.languages.create(name: language) }
      rescue StandardError => e
        ErrorLoggingService.new(e).log("Updating the languages for #{p.github_url} may have caused the issue!")
      end
    end
  end

  private
  def client
    @client ||= Octokit::Client.new(:access_token => Settings.github.auth_token)
  end
end

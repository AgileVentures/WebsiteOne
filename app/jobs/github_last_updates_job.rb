# frozen_string_literal: true

require 'octokit'

module GithubLastUpdatesJob
  extend self

  def run
    Project.with_github_url.each do |p|
      p.last_github_update = client.repo("#{p.github_repo_user_name}/#{p.github_repo_name}").pushed_at
      p.save
    rescue StandardError => e
      ErrorLoggingService.new(e).log("Updating the last update for #{p.github_url} may have caused the issue!")
    end
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: Settings.github.auth_token)
  end
end

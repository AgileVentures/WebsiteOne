require 'octokit'

module GithubLastUpdatesJob
  extend self

  def run
    Project.with_github_url.each do |p|
      begin
        p.last_github_update = client.repo("#{p.github_repo_name}/#{p.github_repo_user_name}").pushed_at
        p.save
      rescue StandardError
        Rails.logger.warn "#{p.github_url} may have caused the issue. Commit terminated for this project!"
      end
    end
  end

  private
  def client
    @client ||= Octokit::Client.new(:access_token => Settings.github.auth_token)
  end
end

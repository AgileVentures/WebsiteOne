require 'octokit'

module GithubJob
  extend self

  def run
      Project.all.each do |p|
        begin
          p.last_github_update = client.repo("#{p.github_repo_name}/#{p.github_repo_user_name}").pushed_at
          p.save
      rescue StandardError
        Rails.logger.warn "#{project.github_url} may have caused the issue. Commit terminated for this project!"
      end
    end
  end

  private
  def client
    @client ||= Octokit::Client.new(:access_token => Settings.github.auth_token)
  end
end

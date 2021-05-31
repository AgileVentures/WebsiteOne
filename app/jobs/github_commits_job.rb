# frozen_string_literal: true

require 'octokit'

module GithubCommitsJob
  extend self

  def initialize
    @client = Octokit::Client.new(client_id: Settings.github.client_id,
                                  client_secret: Settings.github.client_secret)
  end

  def run
    initialize
    Project.with_github_url.each do |project|
      update_total_commit_count_for(project)
      update_user_commit_counts_for(project)
    end
  end

  private

  def update_total_commit_count_for(project)
    commit_count = client.contributors(github_url(project), true, per_page: 100).inject(0) do |memo, contrib|
      memo += contrib.contributions
    end
    project.update(commit_count: commit_count)
  rescue StandardError => e
    ErrorLoggingService.new(e).log("Retrieving total github commits for #{project.github_url} may have caused the following issue!")
  end

  def github_url(project)
    "#{project.github_repo_user_name}/#{project.github_repo_name}"
  end

  def update_user_commit_counts_for(project)
    contributors = get_contributor_stats(project.github_repo)

    contributors.map do |contributor|
      user = User.find_by_github_username(contributor.author.login)

      Rails.logger.warn "#{contributor.author.login} could not be found in the database" unless user

      CommitCount.find_or_initialize_by(user: user, project: project).update(commit_count: contributor.total)
      Rails.logger.info "#{user.display_name} stats are okay"
    rescue StandardError => e
      ErrorLoggingService.new(e).log("Updating contributions for #{contributor.author.login} caused an error!")
    end
  rescue StandardError
    Rails.logger.warn "#{project.github_url} may have caused the issue. Commit2 update terminated for this project!"
  end

  def get_contributor_stats(repo)
    contributors = client.contributor_stats(repo, { retry_timeout: 6, retry_wait: 3 })
    return [] if contributors.nil?

    contributors
  end

  def client
    @client
  end
end

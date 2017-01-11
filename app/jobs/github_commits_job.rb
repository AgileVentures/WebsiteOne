require 'octokit'

module GithubCommitsJob
  extend self

  def run
    Project.with_github_url.each do |project|
      begin
        update_total_commit_count_for(project)
        update_user_commit_counts_for(project)
      rescue Exception
        Rails.logger.warn "#{project.github_url} may have caused the issue. Commit update terminated for this project!"
      end
    end
  end

  private

  def update_total_commit_count_for(project)
    commit_count = client.contributors(github_url(project), true, per_page: 100).reduce(0) do |memo, contrib|
      memo += contrib.contributions
    end

    project.update(commit_count: commit_count, last_github_update: project.updated_at)
  end

  def github_url(project)
    "#{project.github_repo_name}/#{project.github_repo_user_name}"
  end

  def update_user_commit_counts_for(project)
    contributors = get_contributor_stats(project.github_repo)

    contributors.map do |contributor|
      begin
        user = User.find_by_github_username(contributor.author.login)

        Rails.logger.warn "#{contributor.author.login} could not be found in the database" unless user

        CommitCount.find_or_initialize_by(user: user, project: project).update(commit_count: contributor.total)
        Rails.logger.info "#{user.display_name} stats are okay"

      rescue Exception
        Rails.logger.error "#{contributor.author.login} caused an error, but that will not stop me!"
      end
    end
  end

  def get_contributor_stats(repo)
    loop do
      contributors = client.contributor_stats(repo)
      return contributors unless contributors.nil?
      Rails.logger.warn "Waiting for Github to calculate project statistics for #{repo}"
      sleep 3
    end
  end

  def client
    @client ||= Octokit::Client.new(:access_token => Settings.github.auth_token)
  end
end

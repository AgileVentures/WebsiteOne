module GithubCommitsJob
  extend self

  def run
    Project.with_github_url.each do |project|
      update_commit_counts_for(project)
    end
  end

  private

  def update_commit_counts_for(project)
    contributors = Octokit.contributor_stats(project.github_repo)
    contributors.map do |contributor|
      user = User.find_by_github_username(contributor.author.login)
      commit_count = CommitCount.find_or_initialize_by(user: user, project: project).update(commit_count: contributor.total)
    end
  end
end

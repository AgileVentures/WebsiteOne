class GithubCommitsJob
  def self.run
    Project.with_github_url.each do |project|
      CommitCount.update_commit_counts_for(project)
    end
  end
end

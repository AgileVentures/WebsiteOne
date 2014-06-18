class GithubCommitsJob
  def self.run
    Project.all.each do |project|
      CommitCount.update_commit_counts_for(project)
    end
  end
end

module GithubCommitsJob
  extend self

  def run
    Project.with_github_url.each do |project|
      update_commit_counts_for(project)
    end
  end

  private

  def update_commit_counts_for(project)
    contributors_json = fetch_contributor_data(project)
    contributors_json.map do |contributor|
      user = User.find_by_github_username(contributor[:author][:login])
      project.commit_counts.create(user: user, commit_count: contributor[:total]) if user
    end
  end

  def fetch_contributor_data(project)
    JSON.parse(open("https://api.github.com/repos/#{project.github_repo}/stats/contributors").read, symbolize_names: true)
  end
end

require 'nokogiri'

module GithubCommitsJob
  extend self

  def run
    Project.with_github_url.each do |project|
      update_total_commit_count_for(project)
      update_user_commit_counts_for(project)
    end
  end

  private

  def update_total_commit_count_for(project)
    update_protocol(project)
    doc = Nokogiri::HTML(open(project.github_url))
    commit_count = doc.at_css('li.commits .num').text.strip.gsub(',', '').to_i
    project.update(commit_count: commit_count)
  end

  def update_user_commit_counts_for(project)
    contributors = get_contributor_stats(project.github_repo)
    contributors.map do |contributor|
      user = User.find_by_github_username(contributor.author.login)
      CommitCount.find_or_initialize_by(user: user, project: project).update(commit_count: contributor.total) if user
    end
  end

  def get_contributor_stats(repo)
    loop do
      contributors = Octokit.contributor_stats(repo)
      return contributors unless contributors.nil?
      Rails.logger.warn "Waiting for Github to calculate project statistics for #{repo}"
      sleep 3
    end
  end

  def update_protocol(project)
    project.update(github_url: project.github_url.sub('http://', 'https://'))
  end
end

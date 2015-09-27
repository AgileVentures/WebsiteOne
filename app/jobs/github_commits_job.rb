require 'nokogiri'

module GithubCommitsJob
  extend self

  def run
    Project.with_github_url.each do |project|
      update_protocol(project)
      update_total_commit_count_for(project)
      update_user_commit_counts_for(project)
    end
  end

  private

  def update_total_commit_count_for(project)
    begin
      doc = Nokogiri::HTML(open(project.github_url))
      commit_count = doc.at_css('li.commits .num').text.strip.gsub(',', '').to_i
      project.update(commit_count: commit_count)
      puts "Got what I came for from #{project.github_url}".green
    rescue Exception
      puts "I refuse to fail or be stopped by #{project.github_url}!".red
    end
  end

  def update_user_commit_counts_for(project)
    contributors = get_contributor_stats(project.github_repo)
    if contributors
      contributors.map do |contributor|
        begin
          user = User.find_by_github_username(contributor.author.login)
          if user
            CommitCount.find_or_initialize_by(user: user, project: project).update(commit_count: contributor.total)
            puts "#{user.display_name} stats are okay".green
          else
            puts 'Something is Wrooong!'.yellow
          end
        rescue Exception
          puts "#{user.display_name} will not stop me!".red
        end
      end
    end

  end

  def get_contributor_stats(repo)
    begin
      loop do
        contributors = Octokit.contributor_stats(repo)
        return contributors unless contributors.nil?
        Rails.logger.warn "Waiting for Github to calculate project statistics for #{repo}"
        sleep 3
      end
    rescue Exception
      puts "Could not get the contributors for for #{repo}!".red
    end
  end

  def update_protocol(project)
    project.update(github_url: project.github_url.sub('http://', 'https://'))
  end
end

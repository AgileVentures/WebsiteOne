desc "This task is called by the Heroku Scheduler"

task :fetch_github_commits => :environment do
  GithubCommitsJob.run
end

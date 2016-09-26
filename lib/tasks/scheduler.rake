desc "This task is called by the Heroku Scheduler"

task :fetch_github_commits => :environment do
  GithubCommitsJob.run
end

task :karma_calculator => :environment do
  User.all.each do |usr|
    KarmaCalculator.new(usr).perform
    usr.karma.save!
  end
end

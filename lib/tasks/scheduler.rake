desc "This task is called by the Heroku Scheduler"

task :fetch_github_commits => :environment do
  GithubCommitsJob.run
end

task :fetch_github_last_updates => :environment do
  GithubLastUpdatesJob.run
end

task :karma_calculator => :environment do
  events = EventInstance.all.where.not(participants: nil)
    User.all.each do |usr|
      KarmaCalculator.new(usr, events).perform
      usr.karma.save!
    end
end

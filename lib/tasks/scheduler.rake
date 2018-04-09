desc "This task is called by the Heroku Scheduler"

task :fetch_github_commits => :environment do
  GithubCommitsJob.run
end

task :fetch_github_last_updates => :environment do
  GithubLastUpdatesJob.run
end

task :karma_calculator => :environment do
  User.find_each do |usr|
    begin
      KarmaCalculator.new(usr).perform
      usr.karma.save!
    rescue => e
      Rails.logger.error "Error: Occurred while processing KarmaCalculator for User: #{usr.id}"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
    end
  end
end

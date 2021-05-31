# frozen_string_literal: true

desc 'This task is called by the Heroku Scheduler'

task fetch_github_commits: :environment do
  GithubCommitsJob.run
end

task fetch_github_last_updates: :environment do
  GithubLastUpdatesJob.run
end

task fetch_github_languages: :environment do
  GithubLanguagesJob.run
end

task karma_calculator: :environment do
  User.find_each do |user|
    user_karma = Karma.find_or_initialize_by(user_id: user.id)
    user_karma.attributes = KarmaCalculator.new(user).calculate
    user_karma.save!
  rescue StandardError => e
    Rails.logger.error "Error: Occurred while processing KarmaCalculator for User: #{usr.id}"
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join "\n"
  end
end

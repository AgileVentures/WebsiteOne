desc "This task is called by the Heroku Scheduler"

task :fetch_github_commits => :environment do
  GithubCommitsJob.run
end

task :fetch_github_last_updates => :environment do
  GithubLastUpdatesJob.run
end

task :karma_calculator => :environment do
  User.all.each do |usr|
    KarmaCalculator.new(usr)
    if usr.karma
      usr.karma.total = 0
    else
      usr.karma = Karma.find_or_create_by(user_id: usr.id, total: 0)
    end

    usr.karma.total = sum_elements
    return if usr.created_at.blank?
    usr.karma.save!
  end
end

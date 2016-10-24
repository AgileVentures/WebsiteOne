namespace :db do
  desc "Migrate stripe user ids from User model to Subscription model"

  task :migrate_stripe => :environment do
    User.all.each do |user|
      if user.stripe_customer
        # setting time as now not ideal but can set manually later
        UpgradeUserToPremium.with(user, Time.now, user.stripe_customer)
        Logger.new(STDOUT).info user.display_name.bold.blue + " stripe customer id migrated"
      end
    end
    Logger.new(STDOUT).info "migration has been completed".green
  end
end

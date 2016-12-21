namespace :db do
  desc "Migrate stripe user ids from User model to Subscription model"

  task :migrate_stripe => :environment do
    User.all.each do |user|
      if user.stripe_customer
        # setting time as now not ideal but can set manually later
        AddSubscriptionToUserForPlan.with(user,
                               Time.now,
                               user.stripe_customer,
                               Plan.find_by(third_party_identifier: 'premium'))
        Logger.new(STDOUT).info user.display_name.bold.blue + " stripe customer id migrated"
      end
    end
    Logger.new(STDOUT).info "migration has been completed".green
  end
end

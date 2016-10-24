namespace :db do
  desc "Migrate stripe user ids from User model to Subscription model"

  task :migrate_stripe => :environment do
    User.all.each do |user|
      if user.stripe_customer
        user.subscription = Premium.new(started_at: Time.now) # not ideal but can set manually later
        user.subscription.payment_source = PaymentSource::Stripe.new(identifier: user.stripe_customer)
        user.save
        Logger.new(STDOUT).info user.display_name.bold.blue + " stripe customer id migrated"
      end
    end
    Logger.new(STDOUT).info "migration has been completed".green
  end
end

desc "This task creates the set of premium plans"

task :create_plans => :environment do
  Plan.create name: 'Premium', stripe_identifier: 'premium', free_trial_length_days: 7, amount: 1000
  Plan.create name: 'Premium Mob', stripe_identifier: 'premiummob', free_trial_length_days: 0, amount: 2500
  Plan.create name: 'Premium F2F', stripe_identifier: 'premiumf2f', free_trial_length_days: 0, amount: 5000
  Plan.create name: 'Premium Plus', stripe_identifier: 'premiumplus', free_trial_length_days: 0, amount: 10000
end

# frozen_string_literal: true

namespace :db do
  desc 'This task creates the set of premium plans'

  task create_plans: :environment do
    Plan.create name: 'Premium', third_party_identifier: 'premium', free_trial_length_days: 7, amount: 1000
    Plan.create name: 'Premium Mob', third_party_identifier: 'premiummob', free_trial_length_days: 0, amount: 2500
    Plan.create name: 'Premium F2F', third_party_identifier: 'premiumf2f', free_trial_length_days: 0, amount: 5000
    Plan.create name: 'Premium Plus', third_party_identifier: 'premiumplus', free_trial_length_days: 0, amount: 10_000
    Plan.create name: 'Associate', third_party_identifier: 'associate', free_trial_length_days: 0, amount: 500
    Plan.create name: 'NonProfit Basic', third_party_identifier: 'nonprofitbasic', amount: 2000,
                category: 'organization'
    Plan.create name: 'NonProfit Extra', third_party_identifier: 'nonprofitextra', amount: 10_000,
                category: 'organization'
    Plan.create name: 'NonProfit Enterprise', third_party_identifier: 'nonprofitenterprise', amount: 25_000,
                category: 'organization'
  end
end

namespace :paypal do
  desc 'Create paypal plans'
  task create_paypal_plans: :environment do
    Plan.all.each do |plan|
      paypal_plan = PaypalService.new(plan).create_and_activate_recurring_plan
      plan.update paypal_id: paypal_plan.id
    end
  end
end

# frozen_string_literal: true

namespace :db do
  desc 'Migrate Subscriptions away from STI to use composition with Plans'

  task migrate_plans: :environment do
    Subscription.all.each do |subscription|
      plan = Plan.find_by(third_party_identifier: subscription.type.to_s.downcase)
      subscription.plan = plan
      subscription.save
      Logger.new($stdout).info "#{subscription.user.display_name.bold.blue}'s subscription migrated to use Plan'"
    end
    Logger.new($stdout).info 'migration has been completed'.green
  end
end

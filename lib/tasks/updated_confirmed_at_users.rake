# frozen_string_literal: true

namespace :user do
  desc 'updates the confirmed_at column with value of current time for user in an existing database'
  task updated_confirmed_at_users: :environment do
    User.all.each do |user|
      user.update(confirmed_at: DateTime.now)
    end
  end
end
# EOF
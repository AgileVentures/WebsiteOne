# frozen_string_literal: true

namespace :user do
  desc 'Creates an anonymous user in an existing database'
  task create_anonymous: :environment do
    User.create! id: -1, first_name: 'Anonymous', last_name: '', email: 'anonymous@agileventures.org',
                 password: 'temp1234'
  end
end

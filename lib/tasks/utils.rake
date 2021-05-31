# frozen_string_literal: true

namespace :util do
  task 'geocode-all' => [:environment] do
    User.all.each do |user|
      user.geocode
      user.save!
      puts "Successfully geocoded User:#{user.id}"
    end
  end
end

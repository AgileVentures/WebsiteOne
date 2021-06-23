# frozen_string_literal: true

namespace :mailer do
  desc 'sends welcome email to all users'
  task send_welcome_message: :environment do
    User.all.each do |user|
      Mailer.send_welcome_message(user).deliver
      puts "sent welcome email to #{user.email.bold.blue}"
    end
    puts 'completed sending welcome emails'.green
  end
end

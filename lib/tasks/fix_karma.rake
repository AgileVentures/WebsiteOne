# frozen_string_literal: true

task fix_karma: :environment do
  User.all.select { |u| u.karma.nil? }.each { |u| u.karma = Karma.new; u.save }; nil
end

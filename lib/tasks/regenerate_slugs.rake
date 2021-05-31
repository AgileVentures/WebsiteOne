# frozen_string_literal: true

namespace :db do
  desc 'Regenerate the permalinks used in place of ID for REST-ful paths'
  task regenerate_slugs: :environment do
    [Project, User, Document, StaticPage, Event].each do |klass|
      klass.find_each(&:save)
      puts "Completed permalink regeneration for #{klass.name.bold.green} models"
    end
  end
end

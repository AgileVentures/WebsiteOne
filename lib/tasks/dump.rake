# frozen_string_literal: true

require 'seed_dump'

namespace :dump do
  desc 'Dump Event model to file'
  task event: :environment do
    SeedDump.dump(Event.all, file: 'db/seeds/events.rb')
  end
  desc 'Dump EventInstance table from last month to file'
  task event_instance: :environment do
    SeedDump.dump(EventInstance
                  .where('created_at >= :start_date', { start_date: 1.month.ago }),
                  file: 'db/seeds/event_instances.rb')
  end

  desc 'Dump EventInstance table to file'
  task event_instance_all: :environment do
    SeedDump.dump(EventInstance.all, file: 'db/seeds/event_instances.rb')
  end
end

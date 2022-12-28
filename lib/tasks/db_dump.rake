# frozen_string_literal: true

namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database.  Specify RAILS_ENV=production on command line to override.'
    task dump: :environment do
      sql = 'SELECT * FROM %s ORDER BY ID'
      skip_tables = %w(schema_info schema_migrations)
      ApplicationRecord.establish_connection(Rails.env)
      (ApplicationRecord.connection.tables - skip_tables).each do |table_name|
        i = '000'
        File.open("#{Rails.root}/fixtures/#{table_name}.yml.new", 'w+') do |file|
          data = ApplicationRecord.connection.select_all(sql % table_name)
          file.write data.each_with_object({}) { |record, hash|
            hash["#{table_name}_#{i.succ!}"] = record
          }.to_yaml
          puts 'Completed db dump for '.green + table_name.red
        end
      end
    end
  end
end

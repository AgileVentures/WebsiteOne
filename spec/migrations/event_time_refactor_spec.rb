load 'spec/spec_helper.rb'
load 'db/migrate/20110127192508_add_favorite_color_to_users.rb'

describe AddFavoriteColorToUsers do
  before do
    @my_migration_version = '20140725131327_event_combine_date_and_time_fields.rb'
    @previous_migration_version = '20140716134701_import_getting_started_static_page.rb'
  end
  pending 'describe change';
end

describe 'change' do
before do
  ActiveRecord::Migrator.migrate @previous_migration_version
  puts &quot;Testing up migration for #{@my_migration_version} - resetting to #{ActiveRecord::Migrator.current_version}&quot;
                                  end

  it 'adds the 'favorite_color' column to the users table' do
  expect {
    AddFavoriteColorToUsers.up
    User.reset_column_information
  }.to change { User.columns }
  User.columns.map(&amp;:name).should include(&quot;favorite_color&quot;)
end
end
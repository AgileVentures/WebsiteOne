load 'spec/spec_helper.rb'
load 'db/migrate/20140725131327_event_combine_date_and_time_fields.rb'

describe 'EventCombineDateAndTimeFields', type: :migration do
  before do
    @my_migration_version = '20140725131327'
    @previous_migration_version = '20140716134701'
  end
  describe 'up' do
    before do
      EventCombineDateAndTimeFields.new.down
      sql= %Q{INSERT INTO events (name, category, repeats, start_time, event_date, end_time, time_zone) VALUES ('test', 'PairProgramming', 'never', TIME'10:00', DATE'2013-06-17', TIME'11:00', 'UTC');}
      ActiveRecord::Base.connection.execute(sql)
    end
    it 'refactors events time fields' do
      expect {
        EventCombineDateAndTimeFields.new.up
      }.to change { Event.columns }
      event_new = Event.first
      expect(event_new.start_datetime.to_datetime).to eq('2013-06-17 10:00:00'.to_datetime.utc)
      expect(event_new.duration).to eq(60)
    end
    after do
      EventCombineDateAndTimeFields.new.down
    end
  end
end


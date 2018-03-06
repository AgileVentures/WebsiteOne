require 'spec_helper'
load 'db/migrate/20140725131327_event_combine_date_and_time_fields.rb'

ActiveRecord::Migration.verbose = false

describe 'EventCombineDateAndTimeFields', type: :migration do
  describe 'up' do
    before do
      ActiveRecord::Migration.verbose = false

      EventCombineDateAndTimeFields.new.down
      sql= %Q{INSERT INTO events (name, category, repeats, start_time, event_date, end_time, time_zone) VALUES ('test', 'PairProgramming', 'never', TIME'10:00', DATE'2013-06-17', TIME'11:00', 'UTC');}
      ApplicationRecord.connection.execute(sql)
    end

    it 'refactors events time fields' do
      expect {
        EventCombineDateAndTimeFields.new.up
      }.to change { Event.columns }
      event_new = Event.first
      expect(event_new.start_datetime.to_datetime).to eq('2013-06-17 10:00:00'.to_datetime.utc)
      expect(event_new.duration).to eq(60)
    end
  end

  describe 'down' do
    before do
      FactoryBot.create(:event,
                        name: 'every Monday event',
                        category: 'Scrum',
                        start_datetime: 'Mon, 17 Jun 2013 09:00:00 UTC',
                        duration: 60)
    end

    it 'refactors events time fields' do
      expect {
        EventCombineDateAndTimeFields.new.down
      }.to change { Event.columns }
      event_old = Event.first
      expect(event_old.read_attribute(:event_date).to_date).to eq('2013-06-17'.to_date)
      # Postgres stores the time without the date, and when it comes out, the date is set to 2000-01-01.  This may change with different database.
      expect(event_old.read_attribute(:start_time).to_time.utc).to eq('2000-01-01 09:00:00 UTC'.to_time.utc)
      expect(event_old.read_attribute(:end_time).to_time.utc).to eq('2000-01-01 10:00:00 UTC'.to_time.utc)
    end
  end
end


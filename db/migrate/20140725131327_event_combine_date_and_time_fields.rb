# frozen_string_literal: true

class EventCombineDateAndTimeFields < ActiveRecord::Migration[4.2]
  def convert_start_datetime(e)
    Time.utc(e.read_attribute(:event_date).year,
             e.read_attribute(:event_date).month,
             e.read_attribute(:event_date).day,
             e.read_attribute(:start_time).hour,
             e.read_attribute(:start_time).min)
  end

  def convert_duration(e)
    if e.read_attribute(:end_time) < e.read_attribute(:start_time)
      e.write_attribute(:end_time,
                        e.read_attribute(:end_time) + 1.day)
    end
    (e.read_attribute(:end_time) - e.read_attribute(:start_time)).to_i / 60
  end

  def up
    add_column :events, :start_datetime, :datetime
    add_index :events, :start_datetime
    add_column :events, :duration, :integer
    Event.reset_column_information

    Event.all.each do |event|
      event.start_datetime = convert_start_datetime event
      event.duration = convert_duration event
      event.save!
    end
    remove_column :events, :start_time, :time
    remove_column :events, :event_date, :date
    remove_column :events, :end_time, :time
  end

  def down
    add_column :events, :start_time, :time
    add_column :events, :event_date, :date
    add_column :events, :end_time, :time
    Event.reset_column_information

    Event.all.each do |event|
      event.send(:write_attribute, :event_date, event.start_datetime)
      event.send(:write_attribute, :start_time, event.start_datetime)
      event.send(:write_attribute, :end_time, (event.start_datetime + event.duration * 60).utc)
      event.save!
    end
    remove_column :events, :start_datetime, :datetime
    remove_column :events, :duration, :integer
  end
end

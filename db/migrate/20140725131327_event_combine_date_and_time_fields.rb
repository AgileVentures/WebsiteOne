class EventCombineDateAndTimeFields < ActiveRecord::Migration

  def convert_start_datetime(e)
    Time.utc(e.event_date.year, e.event_date.month, e.event_date.day, e.start_time.hour, e.start_time.min)
  end

  def convert_duration(e)
    e.end_time = e.end_time + 1.day if e.end_time < e.start_time
    (e.end_time - e.start_time).to_i/60
  end


  def change
    add_column :events, :start_datetime, :datetime
    add_index :events, :start_datetime
    add_column :events, :duration, :integer
    Event.reset_column_information

    Event.all.each  { |event|
      event.start_datetime = convert_start_datetime event
      event.duration = convert_duration event
      event.save
    }

    remove_column :events, :start_time, :time
    remove_column :events, :event_date, :date
    remove_column :events, :end_time, :time


  end
end


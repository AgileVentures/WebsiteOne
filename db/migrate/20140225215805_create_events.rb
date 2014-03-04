class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :category
      t.text :description
      t.date :event_date, :null => false, :default =>  Date.today
      t.time :start_time, :null => false, :default =>  Time.now
      t.time :end_time, :null => false, :default => Time.now + 30.minutes
      t.string :repeats
      t.integer :repeats_every_n_weeks
      t.integer :repeats_weekly_each_days_of_the_week_mask
      t.boolean :repeat_ends
      t.date :repeat_ends_on
      t.string :time_zone
      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :category
      t.text :description
      t.date :event_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
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

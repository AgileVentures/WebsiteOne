class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.boolean :is_all_day
      t.date :from_date
      t.time :from_time
      t.date :to_date
      t.time :to_time
      t.string :repeats
      t.integer :repeats_every_n_weeks
      t.integer :repeats_weekly_each_days_of_the_week_mask
      t.string :repeat_ends
      t.date :repeat_ends_on
      t.string :time_zone
      t.string :category

      t.timestamps
    end

  end
end

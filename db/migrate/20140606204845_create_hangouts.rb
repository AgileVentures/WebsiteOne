class CreateHangouts < ActiveRecord::Migration
  def change
    create_table :hangouts do |t|
      t.integer :event_id
      t.string :title
      t.string :hangout_url

      t.timestamps
    end
  end
end

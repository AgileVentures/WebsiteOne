# frozen_string_literal: true

class CreateKarmas < ActiveRecord::Migration[4.2]
  def change
    create_table :karmas do |t|
      t.references :user
      t.integer :karma, default: 0
      t.integer :hangouts_attended_with_more_than_one_participant, default: 0

      t.timestamps null: false
    end
  end
end

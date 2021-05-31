# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[4.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :free_trial_length_days
      t.string :third_party_identifier
      t.integer :amount

      t.timestamps null: false
    end
  end
end

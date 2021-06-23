# frozen_string_literal: true

class CreateStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :statuses do |t|
      t.string :status
      t.integer :user_id
      t.timestamps
    end
  end
end

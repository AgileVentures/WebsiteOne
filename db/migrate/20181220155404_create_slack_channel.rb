# frozen_string_literal: true

class CreateSlackChannel < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_channels do |t|
      t.string :environment
      t.string :code
    end
  end
end

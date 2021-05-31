# frozen_string_literal: true

class AddSponsorColumnToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :sponsor_id, :integer
  end
end

class AddSponsorColumnToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :sponsor_id, :integer
  end
end

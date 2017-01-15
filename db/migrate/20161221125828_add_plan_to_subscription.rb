class AddPlanToSubscription < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :plan
  end
end

class AddPlanToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_reference :subscriptions, :plan
  end
end

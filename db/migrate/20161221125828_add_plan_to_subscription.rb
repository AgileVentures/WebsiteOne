# frozen_string_literal: true

class AddPlanToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_reference :subscriptions, :plan
  end
end

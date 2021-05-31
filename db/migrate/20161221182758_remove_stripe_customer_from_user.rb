# frozen_string_literal: true

class RemoveStripeCustomerFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :stripe_customer, :string
  end
end

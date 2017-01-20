class RemoveStripeCustomerFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_customer, :string
  end
end

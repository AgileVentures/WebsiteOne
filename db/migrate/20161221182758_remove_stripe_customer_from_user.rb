class RemoveStripeCustomerFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :stripe_customer, :string
  end
end

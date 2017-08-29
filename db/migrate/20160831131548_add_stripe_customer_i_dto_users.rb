class AddStripeCustomerIDtoUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_customer, :string
  end
end

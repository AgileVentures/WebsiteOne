class AddPaymentSources < ActiveRecord::Migration
  def change
    create_table :payment_sources do |t|

    end
    add_reference(:payment_sources, :subscription)
  end
end

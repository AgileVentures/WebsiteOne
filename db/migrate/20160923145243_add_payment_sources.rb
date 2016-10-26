class AddPaymentSources < ActiveRecord::Migration
  def change
    create_table :payment_sources do |t|
      t.string :type
      t.string :identifier
    end
    add_reference(:payment_sources, :subscription)
  end
end

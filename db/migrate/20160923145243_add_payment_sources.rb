# frozen_string_literal: true

class AddPaymentSources < ActiveRecord::Migration[4.2]
  def change
    create_table :payment_sources do |t|
      t.string :type
      t.string :identifier
    end
    add_reference(:payment_sources, :subscription)
  end
end

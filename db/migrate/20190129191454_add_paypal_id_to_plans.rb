# frozen_string_literal: true

class AddPaypalIdToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :paypal_id, :string
  end
end

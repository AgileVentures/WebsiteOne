class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :free_trial_length_days
      t.string :stripe_identifier
      t.integer :amount

      t.timestamps null: false
    end
  end
end

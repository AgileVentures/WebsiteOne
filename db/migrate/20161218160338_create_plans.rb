class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :free_trial
      t.string :stripe_identifier

      t.timestamps null: false
    end
  end
end

class AddSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.string :type
      t.datetime :started_at
      t.datetime :ended_at
    end
    add_reference(:subscriptions, :user)
  end
end

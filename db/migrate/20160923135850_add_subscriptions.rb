class AddSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :type
    end
    add_reference(:subscriptions, :user)
  end
end

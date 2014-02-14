class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id, null: false
      t.string  :provider, null: false
      t.string  :uid, null: false

      t.timestamps
    end

    add_index :authentications, :user_id
  end
end

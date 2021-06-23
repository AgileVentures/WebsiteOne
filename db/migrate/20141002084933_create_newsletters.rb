# frozen_string_literal: true

class CreateNewsletters < ActiveRecord::Migration[4.2]
  def change
    create_table :newsletters do |t|
      t.string :title, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.boolean :do_send, default: false
      t.boolean :was_sent, default: false
      t.integer :last_user_id, default: 0
      t.datetime :sent_at

      t.timestamps
    end
  end
end

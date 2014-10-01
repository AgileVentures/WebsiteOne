class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :title, null: false
      t.string :subject, null: false
      t.text :body, null: false
      t.boolean :do_send, :boolean, default: false
      t.boolean :was_sent, :boolean, default: false
      t.integer :last_user_id, default: 0
      t.datetime :sent_at

      t.timestamps
    end
  end
end

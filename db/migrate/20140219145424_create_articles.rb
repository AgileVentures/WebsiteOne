class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title, null: false
      t.text :content
      t.string :slug, null: false

      t.timestamps
    end

    add_index :articles, :title
    add_index :articles, :slug, unique: true
  end
end

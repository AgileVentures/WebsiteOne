class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.string :slug, null: false
      t.integer :user_id
      t.string :status
      t.string :slack_channel_name
      t.timestamps
    end
    add_index :courses, :user_id
  end
end

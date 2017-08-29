class CreateStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.string :status
      t.integer :user_id
      t.timestamps
    end
  end
end

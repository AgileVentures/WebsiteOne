class AddCreatorToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :creator_id, :integer, index: true
    add_foreign_key :events, :users, column: :creator_id
  end
end

class AddColumnModifierIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :modifier_id, :integer
  end
end

class AddParentIdToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :parent_id, :integer
  end
end

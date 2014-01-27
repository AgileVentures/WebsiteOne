class AddParentIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :parent_id, :integer
  end
end

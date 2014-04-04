class AddSlugsToModels < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    add_column :projects, :slug, :string
    add_index :projects, :slug, unique: true

    add_column :documents, :slug, :string
    add_index :documents, :slug, unique: true
  end
end

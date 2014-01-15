class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.text :body
      t.integer :project_id

      t.timestamps
    end
  end
end

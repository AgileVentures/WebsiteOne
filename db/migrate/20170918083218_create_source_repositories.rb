class CreateSourceRepositories < ActiveRecord::Migration
  def change
    create_table :source_repositories do |t|
      t.string :url
      t.string :url
      t.references :project

      t.timestamps null: false
    end
  end
end

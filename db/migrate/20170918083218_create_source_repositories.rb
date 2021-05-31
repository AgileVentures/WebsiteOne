# frozen_string_literal: true

class CreateSourceRepositories < ActiveRecord::Migration[4.2]
  def change
    create_table :source_repositories do |t|
      t.string :url
      t.references :project

      t.timestamps null: false
    end
  end
end

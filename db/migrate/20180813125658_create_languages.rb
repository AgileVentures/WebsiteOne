# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name, unique: true
      t.timestamps
    end

    create_table :languages_projects, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :language, index: true
    end
    add_index :languages_projects, %i(project_id language_id), unique: true
  end
end

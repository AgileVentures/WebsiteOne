class RenameStackToLanguages < ActiveRecord::Migration[5.1]
  def change
    rename_table :stacks, :languages
    rename_table :projects_stacks, :languages_projects
    rename_column :languages, :stack, :name
    rename_column :languages_projects, :stack_id, :language_id
  end
end

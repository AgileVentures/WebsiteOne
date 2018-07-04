class AddColumnStackToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :stack, :string, array: true, default: []
  end
end

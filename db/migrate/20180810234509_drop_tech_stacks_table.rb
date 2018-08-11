class DropTechStacksTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :tech_stacks
  end
end

class CreateStacks < ActiveRecord::Migration[5.1]
  def change
    create_table :stacks do |t|
      t.string :stack
      t.timestamps
    end

    create_table :projects_stacks, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :stack, index: true
    end
  end
end

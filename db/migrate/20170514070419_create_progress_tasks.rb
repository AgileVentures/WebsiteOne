class CreateProgressTasks < ActiveRecord::Migration
  def change
    create_table :progress_tasks do |t|
      t.string :title
      t.text   :description

      t.timestamps null: false
    end
  end
end

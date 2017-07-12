class CreateUserProgressTasks < ActiveRecord::Migration
  def change
    create_table :user_progress_tasks do |t|
      t.integer :user_id
      t.integer :progress_task_id
      t.boolean :done

      t.timestamps null: false
    end
  end
end

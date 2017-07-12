class AddOrderNumToProgressTasks < ActiveRecord::Migration
  def change
    add_column :progress_tasks, :order_num, :integer
  end
end

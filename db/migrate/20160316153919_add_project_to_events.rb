class AddProjectToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :project
  end
end

class AddProjectToEvents < ActiveRecord::Migration[4.2]
  def change
    add_reference :events, :project
  end
end

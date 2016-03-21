class AddProjectToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :project
  end
end

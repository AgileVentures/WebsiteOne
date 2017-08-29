class ChangeProjectsAttributes < ActiveRecord::Migration[5.1]
  def up
    change_table :projects do |t|
      t.change :description, :text
    end
  end
end




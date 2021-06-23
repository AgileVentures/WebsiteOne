# frozen_string_literal: true

class ChangeProjectsAttributes < ActiveRecord::Migration[4.2]
  def up
    change_table :projects do |t|
      t.change :description, :text
    end
  end
end

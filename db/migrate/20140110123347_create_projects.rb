# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end

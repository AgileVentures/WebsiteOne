# frozen_string_literal: true

class ChangeColumn < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :pitch, :text
  end
end

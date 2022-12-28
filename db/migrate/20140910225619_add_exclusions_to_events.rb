# frozen_string_literal: true

class AddExclusionsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :exclusions, :text
  end
end

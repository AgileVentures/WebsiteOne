# frozen_string_literal: true

class AddCurrentHoaUrlToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :url, :string
  end
end

# frozen_string_literal: true

class AddUrlSetDirectlyColumnToEventInstance < ActiveRecord::Migration[4.2]
  def change
    add_column :event_instances, :url_set_directly, :boolean, default: false
  end
end

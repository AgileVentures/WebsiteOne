class AddUrlSetDirectlyColumnToEventInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :event_instances, :url_set_directly, :boolean, default: false
  end
end

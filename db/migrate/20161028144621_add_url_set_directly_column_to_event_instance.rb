class AddUrlSetDirectlyColumnToEventInstance < ActiveRecord::Migration
  def change
    add_column :event_instances, :url_set_directly, :boolean, default: false
  end
end

class AddFieldsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :status, :string
    add_column :videos, :host, :string
    add_column :videos, :youtube_id, :string
    add_column :videos, :currently_in, :text
    add_column :videos, :participants, :text
  end
end

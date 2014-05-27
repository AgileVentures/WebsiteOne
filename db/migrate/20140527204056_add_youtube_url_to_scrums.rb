class AddYoutubeUrlToScrums < ActiveRecord::Migration
  def change
    add_column :scrums, :youtube_url, :string
  end
end

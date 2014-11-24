class ImageUrlV1 < ActiveRecord::Migration
  def change
  	add_column :projects, :image_url, :string
  end
end

class AddImageUrlToProjects < ActiveRecord::Migration[5.1]
  def change
  	add_column :projects, :image_url, :string
  end
end

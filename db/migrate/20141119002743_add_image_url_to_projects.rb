# frozen_string_literal: true

class AddImageUrlToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :image_url, :string
  end
end

# frozen_string_literal: true

class RenameKarmaKarmaToTotal < ActiveRecord::Migration[4.2]
  def change
    rename_column :karmas, :karma, :total
  end
end

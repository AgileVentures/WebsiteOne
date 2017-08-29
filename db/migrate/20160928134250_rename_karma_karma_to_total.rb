class RenameKarmaKarmaToTotal < ActiveRecord::Migration[5.1]
  def change
    rename_column :karmas, :karma, :total
  end
end

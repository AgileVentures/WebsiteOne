class RenameKarmaKarmaToTotal < ActiveRecord::Migration
  def change
    rename_column :karmas, :karma, :total
  end
end

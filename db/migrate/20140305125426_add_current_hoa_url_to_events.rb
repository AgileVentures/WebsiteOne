class AddCurrentHoaUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url, :string
  end
end

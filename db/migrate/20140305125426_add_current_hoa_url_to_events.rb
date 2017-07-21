class AddCurrentHoaUrlToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :url, :string
  end
end

class RemoveNewsletter < ActiveRecord::Migration[5.1]
  def change
    drop_table :newsletters
  end
end

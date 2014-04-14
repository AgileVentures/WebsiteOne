class CreateScrums < ActiveRecord::Migration
  def change
    create_table :scrums do |t|
      t.string :title

      t.timestamps
    end
  end
end
